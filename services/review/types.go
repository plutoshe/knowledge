package review

type ReviewQueryBody struct {
	ReviewDate int64    `json:"ReviewDate"`
	HasTag     int      `json:"HasTag"`
	Tags       []string `json:"Tags"`
}

type ReviewUpdateBody struct {
	ReviewDate   int64 `json:"ReviewDate"`
	RememberDate int64 `json:"RememberDate"`
}
