package mongo

import "gopkg.in/mgo.v2/bson"

// type RecordStorageInterface interface {
// 	Add(RecordItem) error
// }

func (r *RecordMongo) Add(query bson.M) error {
	// defer r.waitGroup.Done()
	sessionCopy := r.RecordSession.Copy()
	defer sessionCopy.Close()
	return sessionCopy.DB(r.RecordMongoDB).C(r.RecordMongoColl).Insert(query)

}

func (r *RecordMongo) Query(query bson.M) ([]RecordItem, error) {
	sessionCopy := r.RecordSession.Copy()
	defer sessionCopy.Close()
	result := []RecordItem{}
	err := sessionCopy.DB(r.RecordMongoDB).C(r.RecordMongoColl).Find(query).All(&result)
	return result, err
}
