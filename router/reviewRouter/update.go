package review

import (
	"encoding/json"
	"log"
	"net/http"

	"gopkg.in/mgo.v2/bson"
)

func UnwarpDataFromUpdateRequestBody(r *http.Request) (ReviewUpdateRequestBody, error) {
	decoder := json.NewDecoder(r.Body)
	params := new(ReviewUpdateRequestBody)

	err := decoder.Decode(params)
	return *params, err
}

func (rs *ReviewService) Update(w http.ResponseWriter, r *http.Request) {
	params, err := UnwarpDataFromUpdateRequestBody(r)
	if err != nil {
		log.Println("Error, Msg=%v", err.Error())
		return
	}

	rs.UpdateReviewRecord(ReviewUpdateRequestBody);

	
}
