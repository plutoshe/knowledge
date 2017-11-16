package record

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2/bson"
)

func (rs *RecordService) Query(w *http.ResponseWriter, r *http.Request) {
	querys := r.URL.Query()
	tags := []string{}
	for _, i := range querys["tag"] {
		tags = append(tags, strings.Split(i, ",")...)
	}

	queryRule := bson.M{
		"tags": bson.M{"$all": tags},
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
