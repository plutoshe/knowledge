package record

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/plutoshe/knowledge/helper"
	// "github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"
)

func (rs *RecordService) AddRecord(w *http.ResponseWriter, r *http.Request) {
	// PARAMS

	decoder := json.NewDecoder(r.Body)
	params := new(AddtionBody)
	if err := decoder.Decode(params); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Failed to decode cookie pair request, err:", err)
		return
	}
	log.Println(params)
	log.Println(time.Unix(params.CreateDate, 0))
	log.Println(time.Unix(pwarams.ReviewDate, 0))
	addRule := bson.M{
		"front":         params.FrontContent,
		"back":          params.BackContent,
		"tags":          params.Tags,
		"create_at":     time.Unix(params.CreateDate, 0),
		"review_date":   time.Unix(params.ReviewDate, 0), // review time based on user timezone, assign this type to client later.
		"remember_date": time.Unix(params.ReviewDate, 0),
		"reminder":      params.Reminder,
	}

	if err := rs.RecordStorage.Add(addRule); err != nil {
		helper.WriteHTTPError(*w, helper.ErrInternalServer)
		log.Println("Insert record failed, err:", err)
		return
	}

}
