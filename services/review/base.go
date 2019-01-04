package review

import (
	"log"
	"time"

	"github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"
)

// ReviewService implementing the review interface based on mgo.
type ReviewService struct {
	RecordStorage *mongo.RecordMongo
	ReviewIndex   string
}

func NewReviewService(recordStorage *mongo.RecordMongo, reviewIndex string) *ReviewService {
	return &ReviewService{
		RecordStorage: recordStorage,
		ReviewIndex:   reviewIndex,
	}
}

func (rs *ReviewService) RetrieveData(params ReviewQueryRequestBody) (ReviewQueryResponseBody, error) {
	startTime := time.Now()
	resultUnReviewed, err := rs.RecordStorage.Query(bson.M{
		"review_date": bson.M{
			"$lt": params.ReviewDate,
		},
	})
	if err != nil {
		return ReviewQueryResponseBody{}, err
	}
	resultReviewed, err := rs.RecordStorage.Query(bson.M{
		"remember_date": params.RememberDate,
	})
	if err != nil {
		return ReviewQueryResponseBody{}, err
	}
	log.Println(time.Now().Sub(startTime))
	return ReviewQueryResponseBody{
		UnReviewedRecord: resultUnReviewed,
		ReviewedRecord:   resultReviewed,
	}, nil
}

func (rs *ReviewService) UpdateReviewRecord(params ReviewUpdateRequestBody) error {
	log.Println("===============")
	log.Println(bson.M{"_id": bson.ObjectIdHex(params.RecordID)})
	log.Println(bson.M{
		"review_date":           params.ReviewDate,
		"remember_date":         params.RememberDate,
		"current_review_status": params.CurrentReviewStatus,
	})
	return rs.RecordStorage.Update(
		bson.M{"_id": bson.ObjectIdHex(params.RecordID)},
		bson.M{
			"$set": bson.M{
				"review_date":           params.ReviewDate,
				"remember_date":         params.RememberDate,
				"current_review_status": params.CurrentReviewStatus,
			},
		},
	)
}
