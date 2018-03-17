package review

import "github.com/plutoshe/knowledge/storage/mongo"

type ReviewQueryRequestBody struct {
	ReviewDate   int64    `json:"ReviewDate"`
	RememberDate int64    `json:"RememberDate"`
	HasTag       int      `json:"HasTag"`
	Tags         []string `json:"Tags"`
}

type ReviewQueryResponseBody struct {
	ReviewedRecord   []mongo.RecordItem `json:"ReviewedRecord"`
	UnReviewedRecord []mongo.RecordItem `json:"UnReviewedRecord"`
}

type ReviewUpdateRequestBody struct {
	RecordID            string `json:"RecordID"`
	ReviewDate          int64  `json:"ReviewDate"`
	RememberDate        int64  `json:"RememberDate"`
	CurrentReviewStatus int    `json:"CurrentReviewStatus"`
}
