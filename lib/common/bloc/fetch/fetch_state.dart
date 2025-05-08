
abstract class FetchState{

}

class FetchInitialState extends FetchState{}

class FetchLoadingState extends FetchState{}

class FetchSuccessState extends FetchState{}

class FetchFailureState extends FetchState{
  final String errorMessage;

  FetchFailureState({required this.errorMessage});
}