package reviewRouter

func UnwarpDataFromQueryRequestBody(r *http.Request) (ReviewQueryRequestBody, error) {
	var err error
	params := ReviewQueryRequestBody{
		Tags: strings.Split(r.FormValue("Tags"), ","),
	}
	log.Println(r.FormValue("ReviewDate"))
	params.ReviewDate, err = strconv.ParseInt(r.FormValue("ReviewDate"), 10, 64)
	if err != nil {
		return params, err
	}
	log.Println(r.FormValue("RememberDate"))
	params.RememberDate, err = strconv.ParseInt(r.FormValue("RememberDate"), 10, 64)
	if err != nil {
		return params, err
	}
	params.HasTag, err = strconv.Atoi(r.FormValue("HasTag"))
	return params, nil
}


func (rs *ReviewService) Query(w http.ResponseWriter, r *http.Request) {
	log.Println("In Review Query")
	params, err := UnwarpDataFromQueryRequestBody(r)
	if err != nil {
		helper.WriteHTTPError(w, helper.ErrBadRequestBody)
		log.Printf("Error Msg=%v\n", err.Error())
		return
	}
	// log.Println(params)
	err = rs.RetrieveData(params, w)
	if err != nil {
		helper.WriteHTTPError(w, helper.ErrBadRequestBody)
		log.Printf("Retrive data failed, Error Msg=%v\n", err.Error())
		return
	}
	err = json.NewEncoder(w)
	if err != nil {
		helper.WriteHTTPError(w, helper.ErrBadRequestBody)
		log.Printf("Json encoding failed, Error Msg=%v\n", err.Error())
		return	
	}
}
