import 'package:equatable/equatable.dart';

abstract class MergePdfEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickPdfFilesEvent extends MergePdfEvent {}

class MergePdfFilesEvent extends MergePdfEvent {}
