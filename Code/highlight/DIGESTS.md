## Subresource Integrity

If you are loading Highlight.js via CDN you may wish to use [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) to guarantee that you are using a legimitate build of the library.

To do this you simply need to add the `integrity` attribute for each JavaScript file you download via CDN. These digests are used by the browser to confirm the files downloaded have not been modified.

```html
<script
  src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/highlight.min.js"
  integrity="sha384-pGqTJHE/m20W4oDrfxTVzOutpMhjK3uP/0lReY0Jq/KInpuJSXUnk4WAYbciCLqT"></script>
<!-- including any other grammars you might need to load -->
<script
  src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/languages/go.min.js"
  integrity="sha384-Mtb4EH3R9NMDME1sPQALOYR8KGqwrXAtmc6XGxDd0XaXB23irPKsuET0JjZt5utI"></script>
```

The full list of digests for every file can be found below.

### Digests

```
sha384-qimhSkVWof5rfaFajQk8KAtzSRYyIArcJCMKWdDcNq34F4uplk08wmEyUiYLmO+3 /es/languages/c.js
sha384-5fESKgrRcGs7I/89bn7NKFcHyvIVcmQIG4JfCEAV5Rg5VVtskrmGkHVOIsD1642v /es/languages/c.min.js
sha384-eM9Op3b0ilZ/iW7jeVAMo//MKcEXHCbg1Vf8SMrqds5LIOeF9+3qaX//TsnbItae /es/languages/cpp.js
sha384-+tDHTmLKfBxXgVksRhLEJM4z9PfcGQ2XsrZMDcdJ1SIlPZrtAR4+m4XUX+zJf5nf /es/languages/cpp.min.js
sha384-lU6If27eTyL2Yr+WS3ErF0/raeRKUheLuCM44IUaUshDCTvTeQijobPXY4wgkDGb /es/languages/csharp.js
sha384-k4z6XdU7qI35NxUF8SGumv5kMerrVg/xoat0iSaWnu/dHKoNZKdxZN3gI2WYgMfe /es/languages/csharp.min.js
sha384-DRSBRBp34y5KixP9TEkoyASphUQfWiiqtSP20YveUIY05CjkoCG1wOe8A1cfMIZT /es/languages/glsl.js
sha384-0QXwzWESgZAQ8866ALLJEDZ9l14HhJTWnECXBxJ4DHDmywVn0LRIMqz7JJQWG/AM /es/languages/glsl.min.js
sha384-oQpcUGMBf+VDTHOLQ1uhPp1FgNBo0OZc9gbXGuVFwAogHlkh/Iw6cvKKgcgCQkmV /es/languages/javascript.js
sha384-3T8DJ91yCa1//uY9h8Bo4QLrgEtbz4ILN2x9kSM4QWX9/1kKu6UXC3RAbVQV85UQ /es/languages/javascript.min.js
sha384-R87hRh4kF8+iz2sB6FvLrfR0XZBohjFXeJKIXld1Eji2UVi+M2+OIgJKma/9Ko6u /es/languages/json.js
sha384-QFDPNpqtrgZCuAr70TZJFM4VCY+xNnyGKwJw2EsWIBJOVcWAns9PHcLzecyDVv+x /es/languages/json.min.js
sha384-Tdx2DY9ZTHx3KhVXYqOVKx3q1zOboDGlTTv8sgMlER8y4WETtqL+C4VQ7B4A0OGq /es/languages/xml.js
sha384-n9ZezaAVj8pK1BIFZQxmC1BM9yGuBNRgvsOxHMHPCXzqYd1gSYIu9KjgGEm8K57w /es/languages/xml.min.js
sha384-WHdxyD51Y+ytDdcYGVkKHQOThUwwhLl/1GvZxHTHL4ImI4NS32L/B8bvB/1zN/Mk /languages/c.js
sha384-jtwnwOYA+K4zYN55fA4z4U0PTK5oEp4RcLYaXkYRKO3UUzge1o21ArmvKmTRdh/d /languages/c.min.js
sha384-M2wpTxQe2N0750xYZ0zTinwbmjsZjdtuS7twUUP2dxtHR0YqhY3JuUFyyhANf9Uy /languages/cpp.js
sha384-/yf54L01PbO6NtVs1Pu9rgfNHbKXanLdNcGVuNa0m5+KiyH+1NpZRDK6idm5VoVl /languages/cpp.min.js
sha384-73x+NDGuWTdFik2BOd5uwmBcikSmR+Qx5AVbJLifM/M0hBbwKToQ45xBWxKYkpgd /languages/csharp.js
sha384-6NsOlZtv7W2iSoDU+Yi+hENfl3MuiECvnl7emdRUvpIpDbLvoCjpAU1fjE6HxIQp /languages/csharp.min.js
sha384-FmsaZHRekzHoNL++5S8HZFIJNK42khOgzT3VRksnYVHAURRu3hL5xMgenu9lHyAr /languages/glsl.js
sha384-ubPsF/0wBxL7zEYtpuIL27F0zYtzIZknk+3GdMEcQw1v0Td6xAJ6gDhxHy0UFhk+ /languages/glsl.min.js
sha384-p/utwvqrRVOLlz0BjJ0BCGCb2liTDipfz47/QmGXz9hoPIjCKYEgmYUC30VmGgZy /languages/javascript.js
sha384-L/XmDiyusXomLRGcRmcBpPlboRFjpQNV747OJvg+sEOpgGYvUsNwcC4JLNQ2dI6O /languages/javascript.min.js
sha384-psmmPlbfEWGyvRapexDqkVTgNz7Y1xvlGdLNWQSafI4GFQYFDXPZxVXH1laU4n6l /languages/json.js
sha384-Bb6DhE3tUpBROwypL78TbhRUs9QbCt2GxcxVSYglt2l3MefrYkm4CfwjfWhRfQaX /languages/json.min.js
sha384-QAL2h4IMgQaJUJjUy0dSWdAut7o/A272ai8qOsJ8SSm9KMxkdLgH7oGfLGft/EJ0 /languages/xml.js
sha384-CN3No+n1UZXCFYyl+ge5yAPGTNGuH23BdIsFJxntDmEYL94AmoZlNBHGSdjVSjKG /languages/xml.min.js
sha384-pU6EIwz3WYiM7cjhsGqUGE66xujZX/0DmziiOZenyRfKZDhuLN0sB60ZqL2cCzls /highlight.js
sha384-B+X5vIHa/vRoQ8YSGnNX3B71foDBD54sqiLyMlp/6S1PXFNuGdfiuuNLNY34YFCr /highlight.min.js
```

