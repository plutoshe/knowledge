package record

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2/bson"
)

type QueryBody struct {
	Tags []string `json:"tags"`
}

func (rs *RecordService) Query(w *http.ResponseWriter, r *http.Request) {
	req := json.NewDecoder(r.Body)
	params := QueryBody{}
	if err := req.Decode(params); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadRequestBody)
		log.Println("Failed to decode cookie pair request, err:", err)
		return
	}
	queryRule := bson.M{
		"tags": bson.M{"$in:": params.Tags},
	}
	result, err := rs.RecordStorage.Query(queryRule)
	if err != nil {
		helper.WriteHTTPError(*w, helper.ErrInternalServer)
		log.Println("Query record failed, err:", err)
		return
	}
	output := json.NewEncoder(*w)
	if err := output.Encode(result); err != nil {
		helper.WriteHTTPError(*w, helper.ErrBadJSONBody)
		log.Println("Encode result failed, err:", err)
		return
	}
}
