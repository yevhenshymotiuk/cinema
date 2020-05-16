# Cinema

Implementation of tickets buying system of arbitrary cinema

---

To run project:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Add your SendGrid API key to `config.secret.exs`:
  
    ``` elixir
    config :sendgrid,
      api_key: "<your-api-key>"
    ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
