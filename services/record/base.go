package record

import (
	"net/http"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/storage/mongo"
	"github.com/qiniu/log"
)

type RecordService struct {
	RecordStorage *mongo.RecordMongo
}

var RecordServiceHandler *RecordService

func NewRecordService(recordStorage *mongo.RecordMongo) *RecordService {
	return &RecordService{
		RecordStorage: recordStorage,
	}
}

func AddHandler(mux *http.ServeMux, endpoint string, recordStorage *mongo.RecordMongo) {
	RecordServiceHandler = NewRecordService(recordStorage)
	mux.Handle(
		endpoint,
		RecordServiceHandler,
	)
}

func AddHandlerBaseOnCurrentConfig(mux *http.ServeMux, endpoint string) {
	mux.Handle(
		endpoint,
		RecordServiceHandler,
	)
}

func (rs *RecordService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// entering
	log.Infof("Request to Aggregate CounterHandler, %s", r.URL.Path)

	// Method Examination
	if !helper.AllowMethod(w, r.Method, "GET", "POST") {
		log.Printf("Method is not permitted, request method=%s.", r.Method)
		return
	}

	// Operation
	switch r.Method {
	case "GET":
		//rs.Query(w, r)
		break
	case "POST":
		rs.AddRecord(&w, r)
		break
	}
}
