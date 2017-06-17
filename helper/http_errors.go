package helper

import (
	"encoding/json"
	"net/http"
)

type HTTPError struct {
	// HTTP status code to write into HTTP header.
	// This field should not be marshaled into response
	// JSON body.
	StatusCode int `json:"-"`
	// Deepshare specific error code.
	// Error code can be pragmatically consumed.
	Code int `json:"code"`
	// The error message of the error code.
	// Error message can be printed out and consumed by human.
	Message string `json:"message"`
}

func (he HTTPError) Error() string {
	b, err := json.Marshal(&he)
	if err != nil {
		panic("unexpected json marshal error")
	}
	return string(b)
}

var (
	// common request error
	ErrPathNotFound   = NewHTTPError(http.StatusNotFound, CodePathNotFound)
	ErrInternalServer = NewHTTPError(http.StatusInternalServerError, CodeInternalServer)
	ErrBadJSONBody    = NewHTTPError(http.StatusBadRequest, CodeBadJSONBody)
	ErrBadRequestBody = NewHTTPError(http.StatusBadRequest, CodeBadRequestBody)

	// user errors that related to matching
	ErrMatchNotFound       = NewHTTPError(http.StatusNotFound, CodeMatchNotFound)
	ErrMatchBadParameters  = NewHTTPError(http.StatusBadRequest, CodeMatchBadParameters)
	ErrMatcPuthNeedIPAndUA = NewHTTPError(http.StatusBadRequest, CodeMatchPutNeedIPAndUA)

	// user common error
	ErrAppIDNotFound = NewHTTPError(http.StatusNotFound, CodeAppIDNotFound)

	// user error that related to cookie
	ErrCookieNotFound = NewHTTPError(http.StatusNotFound, CodeCookieNotFound)
)

const (
	CodeBadJSONBody         = 100
	CodeInternalServer      = 101
	CodePathNotFound        = 102
	CodeBadRequestBody      = 103
	CodeTokenNotFound       = 200
	CodeTokenInvalid        = 201
	CodeMatchNotFound       = 300
	CodeMatchBadParameters  = 301
	CodeMatchPutNeedIPAndUA = 302
	CodeAppIDNotFound       = 401
	CodeCookieNotFound      = 500
)

var errMsg = map[int]string{
	CodeBadJSONBody:    "Body is invalid JSON",
	CodeInternalServer: "Internal Server Error",
	CodePathNotFound:   "Failed to find resource at given path",
	CodeBadRequestBody: "Request body is invalid",

	CodeTokenNotFound: "The shorturl token does not exist or is expired",
	CodeTokenInvalid:  "The shorturl token is invalid",

	CodeMatchNotFound:       "Failed to match the provided information with any existing bindings",
	CodeMatchBadParameters:  "Need client_ip and client_ua in parameters",
	CodeMatchPutNeedIPAndUA: "Need client_ip and client_ua in put match body",
	CodeAppIDNotFound:       "Failed to recognize App ID, please make sure you have registered it",

	CodeCookieNotFound: "Faild to get cookieID for the provided device",
}

func NewHTTPError(statusCode, code int) HTTPError {
	return HTTPError{StatusCode: statusCode, Code: code, Message: errMsg[code]}
}
