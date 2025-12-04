//// ------------------------------------------------------------
//// Error Handler
//// ------------------------------------------------------------
////
//// Provides default error response handlers for HTML and JSON
//// formats. Intercepts error status codes and replaces empty
//// responses with user-friendly error messages.
////

import gleam/bool
import gleam/json
import wisp

/// ------------------------------------------------------------
/// Default HTML Error Responses
/// ------------------------------------------------------------
///
/// Middleware that adds HTML error messages to error responses.
/// Wraps the request handler and checks the response status.
/// Success responses (2xx) pass through unchanged. Error status
/// codes receive default HTML error pages. Can be overridden by
/// implementing custom error handlers in your application.
///
pub fn default_html_responses(
  handle_request: fn() -> wisp.Response,
) -> wisp.Response {
  let response = handle_request()

  use <- bool.guard(
    when: response.status >= 200 && response.status < 300,
    return: response,
  )

  // TODO: we need better error messages

  // TODO: add docs to these explaining how they can be overriden

  case response.status {
    404 ->
      "<h1>Not Found</h1>"
      |> wisp.html_body(response, _)

    405 ->
      "<h1>Method Not Allowed</h1>"
      |> wisp.html_body(response, _)

    400 | 422 ->
      "<h1>Bad Request</h1>"
      |> wisp.html_body(response, _)

    413 ->
      "<h1>Request Entity Too Large</h1>"
      |> wisp.html_body(response, _)

    500 ->
      "<h1>Internal Server Error</h1>"
      |> wisp.html_body(response, _)

    _ -> response
  }
}

/// ------------------------------------------------------------
/// Default JSON Error Responses
/// ------------------------------------------------------------
///
/// Middleware that adds JSON error messages to error responses.
/// Wraps the request handler and checks the response status.
/// Success responses (2xx) pass through unchanged. Error status
/// codes receive JSON error objects with an "error" field. Used
/// for API routes to ensure consistent JSON error formatting.
///
pub fn default_json_responses(
  handle_request: fn() -> wisp.Response,
) -> wisp.Response {
  let response = handle_request()

  use <- bool.guard(
    when: response.status >= 200 && response.status < 300,
    return: response,
  )

  case response.status {
    404 ->
      json.object([#("error", json.string("Not Found"))])
      |> json.to_string
      |> wisp.json_body(response, _)

    405 ->
      json.object([#("error", json.string("Method Not Allowed"))])
      |> json.to_string
      |> wisp.json_body(response, _)

    400 | 422 ->
      json.object([#("error", json.string("Bad Request"))])
      |> json.to_string
      |> wisp.json_body(response, _)

    413 ->
      json.object([#("error", json.string("Request Entity Too Large"))])
      |> json.to_string
      |> wisp.json_body(response, _)

    500 ->
      json.object([#("error", json.string("Internal Server Error"))])
      |> json.to_string
      |> wisp.json_body(response, _)

    _ -> response
  }
}
