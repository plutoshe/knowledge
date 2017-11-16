package review

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"
)

func (rs *ReviewService) Query(w *http.ResponseWriter, r *http.Request) {
	queryRule := bson.M{
		"index_name": rs.ReviewIndex,
	}
	indexResult, err := rs.IndexStorage.ReviewIndexQuery(queryRule)
	if err != nil {
		helper.WriteHTTPError(*w, helper.ErrInternalServer)
		log.Println("Query Index collection failed, err:", err)
		return
	}
	var recordResult []mongo.RecordItem

	currentTime := time.Now()
	if len(r.URL.Query()["now"]) != 0 {
		ticks, err := strconv.ParseInt(r.URL.Query()["now"][0], 10, 64)

		if err != nil {
			helper.WriteHTTPError(*w, helper.ErrMatchBadParameters)
			log.Println("Bad params(name: now), err:", err)
			return
		}
		currentTime = time.Unix(ticks, 0)
	}

	if len(indexResult) == 0 || (indexResult[0].ReviewDate.Local().YearDay() != currentTime.YearDay()) {

		limitTime := time.Date(currentTime.Year(), currentTime.Month(), currentTime.Day(), 0, 0, 0, 0, currentTime.Location()).Add(24 * time.Hour)
		recordResult, err = rs.RecordStorage.Query(bson.M{
			"reminder":    bson.M{"$gt": 0},
			"review_date": bson.M{"$lt": limitTime},
		})
		if err != nil {
			helper.WriteHTTPError(*w, helper.ErrInternalServer)
			log.Println("Query record collection failed, err:", err)
			return
		}
		reviewItems := []string{}
		for _, i := range recordResult {
			reviewItems = append(reviewItems, *i.RecordId)
		}
		upsertReviewIndex := bson.M{
			"index_name":   rs.ReviewIndex,
			"review_date":  time.Now(),
			"review_items": reviewItems,
		}
		err = rs.IndexStorage.Upsert(queryRule, upsertReviewIndex)
		if err != nil {
			helper.WriteHTTPError(*w, helper.ErrInternalServer)
			log.Println("update index collection failed, err:", err)
			return
		}
	} else {
		recordResult, err = rs.RecordStorage.Query(bson.M{
			"record_id": bson.M{"$in": indexResult[0].ReviewItems},
		})
		if err != nil {
			helper.WriteHTTPError(*w, helper.ErrInternalServer)
			log.Println("Query record collection failed, err:", err)
			return
		}
	}
	output := json.NewEncoder(*w)
	if err := output.Encode(recordResult); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadJSONBody)
		log.Println("Encode result failed, err:", err)
		return
	}
}
