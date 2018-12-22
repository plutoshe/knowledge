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

func (rs *ReviewService) RetrieveData(params ReviewQueryRequestBody) (ReviewQueryResponseBody, error) {
	startTime := time.Now()
	resultUnReviewed, err := rs.RecordStorage.Query(bson.M{
		"review_date": bson.M{
			"$lt": params.ReviewDate,
		},
	})
	if err != nil {
		return nil, err
	}
	resultReviewed, err := rs.RecordStorage.Query(bson.M{
		"remember_date": params.RememberDate,
	})
	if err != nil {
		return nil, err
	}
	log.Println(time.Now().Sub(startTime))
	return ReviewQueryResponseBody{
		UnReviewedRecord: resultUnReviewed,
		ReviewedRecord:   resultReviewed,
	}, nil
}
