package helper

import (
	"net/http"
	"testing"
)

func TestParseClientIP(t *testing.T) {
	tests := []struct {
		xForwardfor string
		remoteAddr  string
		expectedIP  string
	}{
		{
			xForwardfor: "",
			remoteAddr:  "testip:testport",
			expectedIP:  "testip",
		},
		{

			xForwardfor: "testip",
			remoteAddr:  "proxyip:testport",
			expectedIP:  "testip",
		},
		{
			xForwardfor: "testip, proxy1ip",
			remoteAddr:  "proxy2ip:testport",
			expectedIP:  "testip",
		},
		{
			xForwardfor: "",
			remoteAddr:  "",
			expectedIP:  "",
		},
	}

	for i, tt := range tests {
		r := &http.Request{
			Header: make(http.Header),
		}
		if tt.xForwardfor != "" {
			r.Header.Set("X-Forwarded-For", tt.xForwardfor)
		}
		r.RemoteAddr = tt.remoteAddr

		ip := ParseClientIP(r)
		if ip != tt.expectedIP {
			t.Errorf("#%d parse client ip failed, ip = %s, want = %s\n", i, ip, tt.expectedIP)
		}
	}
}
