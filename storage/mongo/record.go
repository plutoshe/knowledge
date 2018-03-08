package mongo

import (
	"github.com/plutoshe/knowledge/helper"
)

func NewRecordMongo(recordMongoAddr, recordMongoDB, recordMongoColl string, relinkNum int) *RecordMongo {
	return &RecordMongo{
		RecordMongoAddr: recordMongoAddr,
		RecordMongoDB:   recordMongoDB,
		RecordMongoColl: recordMongoColl,
		RecordSession:   helper.MustCreateMongoSession(recordMongoAddr),
		RelinkNum:       relinkNum,
	}
}

func (r *RecordMongo) Close() {
	r.RecordSession.Close()
}
