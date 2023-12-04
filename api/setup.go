package api

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/jayofelony/pwngrid/crypto"
	"github.com/jayofelony/pwngrid/mesh"

	_ "github.com/jinzhu/gorm/dialects/mysql"

	"github.com/evilsocket/islazy/log"
)

type API struct {
	Router *chi.Mux
	Keys   *crypto.KeyPair
	Peer   *mesh.Peer
	Mesh   *mesh.Router
	Client *Client
}

func Setup(keys *crypto.KeyPair, peer *mesh.Peer, router *mesh.Router, Endpoint string) (err error, api *API) {
	api = &API{
		Router: chi.NewRouter(),
		Keys:   keys,
		Peer:   peer,
		Mesh:   router,
		Client: NewClient(keys, Endpoint),
	}

	api.Router.Use(CORS)
	if api.Keys == nil {
		api.setupServerRoutes()
	} else {
		api.setupPeerRoutes()
	}

	return
}

func (api *API) Run(addr string) {
	log.Info("pwngrid api starting on %s ...", addr)
	log.Fatal("%v", http.ListenAndServe(addr, api.Router))
}
