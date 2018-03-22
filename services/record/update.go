package record

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/plutoshe/knowledge/helper"
	"github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"
)

type updateBody = mongo.RecordItem

func (rs *RecordService) Update(w *http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	params := new(updateBody)
	log.Println(r.Body)
	if err := decoder.Decode(params); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Failed to decode cookie pair request, err:", err)
		return
	}

	// type conversion
	var query_bson, update_bson bson.M
	query_bson = bson.M{"_id": params.RecordID}
	bsonBytes, _ := bson.Marshal(params)
	bson.Unmarshal(bsonBytes, &update_bson)
	if err := rs.RecordStorage.Update(query_bson, update_bson); err != nil {
		helper.WriteHTTPError(*w, helper.ErrInternalServer)
		log.Println("Insert record failed, err:", err)
		return
	}

}
