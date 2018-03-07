package review

import (
	"encoding/json"
	"net/http"
)

func UnwarpDataFromRquestBody(r *http.Request) (ReviewBody, error) {
	decoder := json.NewDecoder(r.Body)
	params := new(ReviewBody)
	err := decoder.Decode(&params)
	return params, err
}

func (rs *ReviewService) RetrieveData(params ReviewBody) []mongo.RecordItem {
    resultNotReviewed, err := rs.RecordStorage.Query(bson.M{
        "review_date" : {
            "$gt": time.Unix(params.ReviewDate, 0),
        },
    })
    resultReviewed, err := rs.RecordStorage.Query(bson.M{
        "remember_date" : time.Unix(params.ReviewDate, 0),
    })
    result = resultNotReviewed.append(resultReviewed...)
}

func (rs *ReviewService) Query(w *http.ResponseWriter, r *http.Request) {
	params, err := UnwarpDataFromRquestBody(r)
    if err := nil {
        log.Println("Error Msg=%v", err.Error())
        return
    }
    RetrieveData()

}
