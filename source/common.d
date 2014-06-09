module common;

mixin template Singleton(T) {
	private {
		static T _instance;
		this() {}
	}

	static T getInstance() {
		if (_instance is null)
			_instance = new T();
		return _instance;
	}
}