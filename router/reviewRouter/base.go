package reviewRouter

var ReviewServiceHandler *ReviewRouter


func AddHandler(mux *http.ServeMux, endpoint string, ReviewService) {
	ReviewServiceHandler = NewReviewService(recordStorage, reviewIndex)
	mux.Handle(
		endpoint,
		ReviewServiceHandler,
	)
}

func AddHandlerBaseOnCurrentConfig(mux *http.ServeMux, endpoint string) {
	mux.Handle(
		endpoint,
		ReviewServiceHandler,
	)
}

// operation router
func (rs *ReviewService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// Method Examination
	// if !helper.AllowMethod(w, r.Method, "GET") {
	// 	log.Printf("Method is not permitted, request method=%s.", r.Method)
	// 	return
	// }

	// Operation
	log.Println(r.Header)
	switch r.Method {
	case "GET":
		rs.Query(w, r)
		break
	case "PUT":
		rs.Update(w, r)
	}
}
