import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class MergePdfState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PdfInitial extends MergePdfState {}

class PdfFilesPicked extends MergePdfState {
  final File pdf1;
  final File pdf2;
  final String fileName1;
  final String fileName2;

  PdfFilesPicked({
    required this.pdf1,
    required this.pdf2,
    required this.fileName1,
    required this.fileName2,
  });

  @override
  List<Object?> get props => [pdf1, pdf2, fileName1, fileName2];
}

class PdfMerging extends MergePdfState {}

class PdfMerged extends MergePdfState {
  final String filePath;

  PdfMerged({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class PdfMergeError extends MergePdfState {
  final String error;

  PdfMergeError(this.error);

  @override
  List<Object?> get props => [error];
}
