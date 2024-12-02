import 'dart:io';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'merge_pdf_events.dart';
import 'merge_pdf_states.dart';
import 'package:file_picker/file_picker.dart';

class MergePdfBloc extends Bloc<MergePdfEvent, MergePdfState> {
  File? _pdfFile1;
  File? _pdfFile2;

  MergePdfBloc() : super(PdfInitial()) {
    on<PickPdfFilesEvent>((event, emit) async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: true,
        );

        if (result != null && result.files.length == 2) {
          _pdfFile1 = File(result.files[0].path!);
          _pdfFile2 = File(result.files[1].path!);
          emit(PdfFilesPicked(
            pdf1: _pdfFile1!,
            pdf2: _pdfFile2!,
            fileName1: result.files[0].name,
            fileName2: result.files[1].name,
          ));
        } else {
          emit(PdfMergeError('Selecione exatamente dois arquivos PDF.'));
        }
      } catch (e) {
        emit(PdfMergeError(e.toString()));
      }
    });

    on<MergePdfFilesEvent>((event, emit) async {
      if (_pdfFile1 == null || _pdfFile2 == null) {
        emit(PdfMergeError('Arquivos PDF não selecionados.'));
        return;
      }

      emit(PdfMerging());

      try {
        final PdfDocument document1 = PdfDocument(inputBytes: _pdfFile1!.readAsBytesSync());
        final PdfDocument document2 = PdfDocument(inputBytes: _pdfFile2!.readAsBytesSync());

        final PdfDocument mergedDocument = PdfDocument();

        for (int i = 0; i < document1.pages.count; i++) {
          mergedDocument.pages.add().graphics.drawPdfTemplate(document1.pages[i].createTemplate(), Offset.zero);
        }

        for (int i = 0; i < document2.pages.count; i++) {
          mergedDocument.pages.add().graphics.drawPdfTemplate(document2.pages[i].createTemplate(), Offset.zero);
        }

        // Solicitar ao usuário o local para salvar o arquivo
        String? savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Selecione o local para salvar o arquivo combinado',
          fileName: 'merged_document.pdf',
        );

        if (savePath == null) {
          emit(PdfMergeError('Ação de salvar cancelada pelo usuário.'));
          return;
        }

        // Salvar o arquivo combinado
        final List<int> bytes = mergedDocument.saveSync();
        File(savePath).writeAsBytesSync(bytes);

        document1.dispose();
        document2.dispose();
        mergedDocument.dispose();

        emit(PdfMerged(filePath: savePath));
      } catch (e) {
        emit(PdfMergeError(e.toString()));
      }
    });
  }
}
