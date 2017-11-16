package mongo

import "gopkg.in/mgo.v2/bson"

func (im *IndexMongo) ReviewIndexQuery(query bson.M) ([]ReviewIndex, error) {
	sessionCopy := im.IndexSession.Copy()
	defer sessionCopy.Close()
	result := []ReviewIndex{}
	err := sessionCopy.DB(im.IndexMongoDB).C(im.IndexMongoColl).Find(query).All(&result)
	return result, err
}

func (im *IndexMongo) Upsert(query bson.M, update bson.M) error {
	sessionCopy := im.IndexSession.Copy()
	defer sessionCopy.Close()
	_, err := sessionCopy.DB(im.IndexMongoDB).C(im.IndexMongoColl).Upsert(query, update)
	return err
}
