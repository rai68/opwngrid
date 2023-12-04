package api

import (
	"github.com/go-chi/chi/v5"
	"github.com/jayofelony/pwngrid/models"
	"net/http"
)

func (api *API) ShowUnit(w http.ResponseWriter, r *http.Request) {
	unitFingerprint := chi.URLParam(r, "fingerprint")
	if unit := models.FindUnitByFingerprint(unitFingerprint); unit == nil {
		ERROR(w, http.StatusNotFound, ErrEmpty)
		return
	} else {
		JSON(w, http.StatusOK, unit)
	}
}
