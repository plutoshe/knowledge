package review

import (
	"net/http"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/storage/mongo"
	"github.com/qiniu/log"
)

type ReviewService struct {
	RecordStorage *mongo.RecordMongo
	ReviewIndex   string
}

var ReviewServiceHandler *ReviewService

func NewReviewService(recordStorage *mongo.RecordMongo, reviewIndex string) *ReviewService {
	return &ReviewService{
		RecordStorage: recordStorage,
		ReviewIndex:   reviewIndex,
	}
}

func AddHandler(mux *http.ServeMux, endpoint string, recordStorage *mongo.RecordMongo, reviewIndex string) {
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
	if !helper.AllowMethod(w, r.Method, "GET") {
		log.Printf("Method is not permitted, request method=%s.", r.Method)
		return
	}

	// Operation
	switch r.Method {
	case "GET":
		rs.Query(&w, r)
		break
	case "PUT":
		rs.Update(&w, r)
	}
}
