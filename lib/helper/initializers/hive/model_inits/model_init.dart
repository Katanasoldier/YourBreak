/// Abstract class for every model init file.
/// All Hive model initializer classes should implement this interface.
/// 
/// This makes sure that each init class provides a standardized `init()` 
/// method, which performs tasks like:
/// - Registering adapters for the model
/// - Opening necessary boxes
/// - Inserting preset or default data
/// 
/// Using this abstract class allows `hive_initializer` to iterate over 
/// a list of all model init classes and call `init()` on each one 
/// in a type-safe and consistent way.
abstract class ModelInit {
  Future<void> init();
}