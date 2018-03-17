package mongo

import (
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

type RecordItem struct {
	RecordID            bson.ObjectId `json:"RecordID" bson:"_id"`
	Front               []Content     `json:"Front" bson:"front"`
	Back                []Content     `json:"Back" bson:"back"`
	CreateDate          int64         `json:"CreateDate" bson:"create_date"`
	ReviewDate          int64         `json:"ReviewDate" bson:"review_date"`
	RememberDate        int64         `json:"RememberDate" bson:"remember_date"`
	Tags                []string      `json:"Tags" bson:"tags"`
	Reminder            int           `json:"Reminder" bson:"reminder"`
	CurrentReviewStatus int           `json:"CurrentReviewStatus" bson:"current_review_status"`
}

type Content struct {
	Form  string `json:"Form" bson:"form"`
	Data  string `json:"Data" bson:"data"`
	Cover int    `json:"Cover"`
}

type RecordMongo struct {
	RecordMongoDB   string
	RecordMongoColl string
	RecordMongoAddr string
	RecordSession   *mgo.Session
	// waitGroup       sync.WaitGroup
	RelinkNum int
}
