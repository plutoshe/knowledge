package record

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"
)

type AddtionContent struct {
	Form  string `json:"form"`
	Data  string `json:"data"`
	Cover int    `json:"cover"`
}

type AddtionBody struct {
	Content  []AddtionContent `json:content`
	Tags     []string         `json:"tags"`
	Reminder int              `json:"reminder"`
}

func (rs *RecordService) AddRecord(w *http.ResponseWriter, r *http.Request) {
	// PARAMS
	decoder := json.NewDecoder(r.Body)
	params := new(AddtionBody)
	log.Println(r.Body)
	if err := decoder.Decode(params); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Failed to decode cookie pair request, err:", err)
		return
	}

	// type conversion
	var front, back []mongo.Content
	for _, v := range params.Content {
		cv := mongo.Content{
			Form: v.Form,
			Data: v.Data,
		}
		if v.Cover == 0 {
			front = append(front, cv)
		} else {
			back = append(back, cv)
		}

	}

	addRule := bson.M{
		"front":       front,
		"back":        back,
		"create_at":   time.Now(),
		"tags":        params.Tags,
		"review_date": time.Now().Add(time.Duration(params.Reminder) * 24 * time.Hour),
		"reminder":    params.Reminder,
	}

	if err := rs.RecordStorage.Add(addRule); err != nil {
		helper.WriteHTTPError(*w, helper.ErrInternalServer)
		log.Println("Insert record failed, err:", err)
		return
	}

}
