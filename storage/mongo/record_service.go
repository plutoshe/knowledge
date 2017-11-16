package mongo

import "gopkg.in/mgo.v2/bson"

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

func (r *RecordMongo) Update(query bson.M, update bson.M) error {
	sessionCopy := r.RecordSession.Copy()
	defer sessionCopy.Close()
	return sessionCopy.DB(r.RecordMongoDB).C(r.RecordMongoColl).Update(query, update)
}
