package review

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2/bson"
)

func UnwarpDataFromQueryRequestBody(r *http.Request) (ReviewQueryRequestBody, error) {
	var err error
	params := ReviewQueryRequestBody{
		Tags: strings.Split(r.FormValue("Tags"), ","),
	}
	log.Println(r.FormValue("ReviewDate"))
	params.ReviewDate, err = strconv.ParseInt(r.FormValue("ReviewDate"), 10, 64)
	if err != nil {
		return params, err
	}
	params.HasTag, err = strconv.Atoi(r.FormValue("HasTag"))
	return params, nil
}

func (rs *ReviewService) RetrieveData(params ReviewQueryRequestBody, w *http.ResponseWriter) error {
	resultUnReviewed, err := rs.RecordStorage.Query(bson.M{
		"review_date": bson.M{
			"$lt": time.Unix(params.ReviewDate, 0),
		},
	})
	if err != nil {
		return err
	}
	resultReviewed, err := rs.RecordStorage.Query(bson.M{
		"remember_date": time.Unix(params.ReviewDate, 0),
	})
	if err != nil {
		return err
	}
	result := ReviewQueryResponseBody{
		UnReviewedRecord: resultUnReviewed,
		ReviewedRecord:   resultReviewed,
	}
	log.Println(result)
	encode := json.NewEncoder(*w)
	return encode.Encode(result)
}

func (rs *ReviewService) Query(w *http.ResponseWriter, r *http.Request) {
	log.Println("In Review Query")

	params, err := UnwarpDataFromQueryRequestBody(r)
	if err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Error Msg=%v", err.Error())
		return
	}
	log.Println(params)
	err = rs.RetrieveData(params, w)
	if err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Error Msg=%v", err.Error())
		return
	}
}
