sealed class Result<T, E> {
    const Result();

    factory Result.ok(T value) => Ok(value: value);
    factory Result.err(E error) => Err(error: error);
}

class Ok<T, E> extends Result<T, E> {
    final T value;

    const Ok({required this.value});
}

class Err<T, E> extends Result<T, E> {
    final E error;

    const Err({required this.error});
}
