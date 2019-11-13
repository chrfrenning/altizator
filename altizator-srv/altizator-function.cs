using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net;
using System.Net.Http;
using Newtonsoft.Json.Linq;

namespace altizator_srv
{
    public static class Altizator
    {
        // NOTE: Very first and untested raw scaffold, good night now, coming back after rest

        static readonly string CosmosEndpoint = "https://altizator00cac938.documents.azure.com:443";
        static readonly string ImageDescriptionUrlFrag = "/vision/v2.0/describe";
        static readonly string CogServAppKeyHeaderName = "Ocp-Apim-Subscription-Key";
        static readonly string CosmosKey = "vdl3KWba3u10XPJ1C7GZoF48eDh7NV7egTxLmLXWcrYEEvoCqNO5DRqvIg1w2FmQgB1nm8yKisu72tkl26tg1g==";
        static readonly string CognitiveServicesEndpoint = "https://westeurope.api.cognitive.microsoft.com/";
        static readonly string CognitiveServicesKey = "d811f73f9c48462c867b5578dea308c3";

        [FunctionName("TagImageByUrl")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req, ILogger log)
        {
            log.LogInformation("Hellow world.");

            string imageUrlToDescribe = req.Query["i"];

            HttpClient csClient = new HttpClient();
            csClient.DefaultRequestHeaders.Add(CogServAppKeyHeaderName, CognitiveServicesKey);
            var resultData = await csClient.GetAsync(CosmosEndpoint + ImageDescriptionUrlFrag);
            JObject json = (JObject)JToken.Parse(resultData.ToString());
            string imgDescription = json.SelectToken("description.captions[0].text").ToString();

            return imgDescription != null
                ? (ActionResult)new OkObjectResult(imgDescription)
                : new BadRequestObjectResult("Please pass an image url to describe in the 'i' query string param.");
        }
    }
}
