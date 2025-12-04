//// ------------------------------------------------------------
//// HTTP Kernel
//// ------------------------------------------------------------
////
//// Core HTTP kernel types that define the middleware group
//// classifications. Used to determine which middleware stack
//// is applied to different types of routes.
////

/// ------------------------------------------------------------
/// MiddlewareGroup Type
/// ------------------------------------------------------------
///
/// Defines the type of middleware stack to apply to routes.
/// Web routes use HTML error responses and serve static files,
/// while Api routes use JSON error responses. Custom groups
/// allow for application-specific middleware configurations.
///
pub type MiddlewareGroup {
  Web
  Api
  Custom(String)
}
