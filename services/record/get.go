package record

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2/bson"
)

func (rs *RecordService) GetMethod(w *http.ResponseWriter, r *http.Request) {
	querys := r.URL.Query()
	tags := []string{}
	queryRule := bson.M{}

	if len(querys["tag"]) > 0 {
		for _, i := range querys["tag"] {
			tags = append(tags, strings.Split(i, ",")...)
		}
		queryRule["tags"] = bson.M{"$all": tags}
	}
	if len(querys["keyword"]) > 0 {
		regexRule := ".*" + querys["keyword"][0] + ".*"
		queryRule = bson.M{"$or": []bson.M{
			bson.M{"front.data": bson.M{"$regex": regexRule}},
			bson.M{"back.data": bson.M{"$regex": regexRule}},
		}}
	}
	log.Println(queryRule)
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
