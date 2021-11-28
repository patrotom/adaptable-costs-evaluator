defmodule AdaptableCostsEvaluatorWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server, License, SecurityScheme, Contact}
  alias AdaptableCostsEvaluatorWeb.{Endpoint, Router}
  @behaviour OpenApi

  @dialyzer {:nowarn_function, spec: 0}

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: System.get_env("APP_NAME", "Adaptable Costs Evaluator"),
        version: Mix.Project.config()[:version],
        description:
          System.get_env(
            "APP_DESCRIPTION",
            "REST API for the Adaptable Costs Evaluator application."
          ),
        license: %License{
          name: "MIT License",
          url: "https://github.com/patrotom/adaptable-costs-evaluator/blob/master/LICENSE"
        },
        contact: %Contact{
          email: "tomas.patro@gmail.com",
          name: "Tomáš Patro"
        }
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "JWT" => %SecurityScheme{
            name: "JWT HTTP Authorization",
            type: "http",
            scheme: "bearer",
            bearerFormat: "JWT"
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
