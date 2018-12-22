package review

import (
	"encoding/json"
	"log"
	"net/http"
	"path"
	"strconv"

	"github.com/MISingularity/deepshare2/pkg/testutil"
	"github.com/plutoshe/knowledge/api"
	"github.com/plutoshe/knowledge/storage/mongo"
	"gopkg.in/mgo.v2/bson"

	"testing"
	"time"
)

var currentTime = time.Now()

var data = []bson.M{bson.M{
	"front":       []mongo.Content{mongo.Content{Form: "TEXT", Data: "data1"}},
	"back":        []mongo.Content{mongo.Content{Form: "TEXT", Data: "data1"}, mongo.Content{Form: "TEXT", Data: "data1"}},
	"review_date": time.Date(currentTime.Year(), currentTime.Month(), currentTime.Day(), 0, 0, 0, 0, currentTime.Location()),
	"reminder":    3,
},
	bson.M{
		"front":       []mongo.Content{},
		"back":        []mongo.Content{mongo.Content{Form: "TEXT", Data: "data2"}, mongo.Content{Form: "TEXT", Data: "data2"}},
		"review_date": time.Date(currentTime.Year(), currentTime.Month(), currentTime.Day(), 0, 0, 0, 0, currentTime.Location()),
		"reminder":    0,
	},

	bson.M{
		"front":       []mongo.Content{mongo.Content{Form: "TEXT", Data: "data3"}, mongo.Content{Form: "TEXT", Data: "data3"}},
		"back":        []mongo.Content{},
		"review_date": time.Date(currentTime.Year(), currentTime.Month(), currentTime.Day(), 0, 0, 0, 0, currentTime.Location()).Add(time.Hour * 36),
		"reminder":    7,
	},

	bson.M{
		"front":       []mongo.Content{mongo.Content{Form: "TEXT", Data: "data4"}},
		"back":        []mongo.Content{mongo.Content{Form: "TEXT", Data: "data4"}, mongo.Content{Form: "TEXT", Data: "data4"}},
		"review_date": time.Date(currentTime.Year(), currentTime.Month(), currentTime.Day(), 0, 0, 0, 0, currentTime.Location()).Add(time.Hour * -106),
		"reminder":    30,
	}}
var test_result string

func prepareRecord(recordStorage *mongo.RecordMongo, currentTime time.Time) {
	for _, i := range data {
		recordStorage.Add(i)
	}
}

func TestReviewQuery(t *testing.T) {
	MongoTestingAddr := "127.0.0.1:27017"
	MongoDBName := "review_test"

	recordStorage := mongo.NewRecordMongo(MongoTestingAddr, MongoDBName, "review_test_record", 5)
	indexStorage := mongo.NewIndexMongo(MongoTestingAddr, MongoDBName, "review_test_index", 5)
	defer recordStorage.Close()
	defer indexStorage.Close()
	defer recordStorage.RecordSession.DB(MongoDBName).DropDatabase()

	prepareRecord(recordStorage, currentTime)

	tests := []struct {
		wcode int
	}{
		{
			http.StatusOK,
		},
	}
	ReviewServiceHandler = NewReviewService(recordStorage, indexStorage, "review")
	// Do some GET requests with different channel IDs and event filters.
	for i, tt := range tests {
		var url string
		url = "http://" + path.Join("example.com", api.ReviewPrefix) + "?now=" + strconv.FormatInt(currentTime.Unix(), 10)
		log.Println(url)
		w := testutil.HandleWithBody(ReviewServiceHandler, "GET", url, "")

		if w.Code != tt.wcode {
			t.Errorf("#%d: HTTP status code = %d, want = %d", i, w.Code, tt.wcode)
		}

		// if string(w.Body.Bytes()) != tt.wbody {
		// 	t.Errorf("#%d: HTTP response body = %q, want = %q", i, string(w.Body.Bytes()), tt.wbody)
		// }
		result := []mongo.RecordItem{}
		err := json.Unmarshal(w.Body.Bytes(), &result)
		if err != nil {
			t.Error(err)
		}
		if len(result) != 2 {
			t.Errorf("#%d: HTTP result = %d, want = %d", i, len(result), 2)
		}

	}

}
