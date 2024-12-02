import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/merge_pdf_bloc.dart';
import '../bloc/merge_pdf_states.dart';
import '../bloc/merge_pdf_events.dart';

class MergePdfPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MergePdfBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Juntar PDFs')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                bloc.add(PickPdfFilesEvent());
              },
              child: Text('Selecionar dois PDFs'),
            ),
            SizedBox(height: 20),
            BlocBuilder<MergePdfBloc, MergePdfState>(
              builder: (context, state) {
                if (state is PdfFilesPicked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Arquivo 1: ${state.fileName1}'),
                      Text('Arquivo 2: ${state.fileName2}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          bloc.add(MergePdfFilesEvent());
                        },
                        child: Text('Juntar PDFs'),
                      ),
                    ],
                  );
                } else if (state is PdfMerging) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PdfMerged) {
                  return Text('PDF combinado salvo em: ${state.filePath}');
                } else if (state is PdfMergeError) {
                  return Text('Erro: ${state.error}', style: TextStyle(color: Colors.red));
                } else {
                  return Text('Selecione dois arquivos PDF.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
