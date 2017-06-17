package helper

import (
	"net"
	"net/http"
	"strings"

	"github.com/MISingularity/NiServer/pkg/log"
)

// allowMethod verifies that the given method is one of the allowed methods,
// and if not, it writes an error to w.  A boolean is returned indicating
// whether or not the method is allowed.
func AllowMethod(w http.ResponseWriter, m string, ms ...string) bool {
	for _, meth := range ms {
		if m == meth {
			return true
		}
	}
	w.Header().Set("Allow", strings.Join(ms, ","))
	http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
	return false
}

func WriteHTTPError(w http.ResponseWriter, err HTTPError) {
	http.Error(w, err.Error(), err.StatusCode)
}

func RequestLogger(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Infof("REQUEST [%s] %s, remote: %s", r.Method, r.RequestURI, r.RemoteAddr)
		handler.ServeHTTP(w, r)
		log.Infof("RESPONSE [%s] %s, remote: %s", r.Method, r.RequestURI, r.RemoteAddr)
	})
}

func ParseClientIP(r *http.Request) string {
	xForwardFor := r.Header.Get("X-Forwarded-For")
	ip := ""
	if xForwardFor != "" {
		ip = strings.Split(xForwardFor, ", ")[0]
		log.Debugf("HttpUtil; xForwardFor exsit; ip: %s; X-Forwarded-For: %s", ip, xForwardFor)
	} else {
		var err error
		ip, _, err = net.SplitHostPort(r.RemoteAddr)
		if err != nil {
			log.Errorf("HttpUtil; SplitHostPort error; RemoteAddr: %s", r.RemoteAddr)
			return ""
		}
	}

	return ip
}
