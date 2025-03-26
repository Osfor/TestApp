var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

//reads docker run args and overrides settings
builder.Configuration
    .AddJsonFile("appsettings.json")
    .AddCommandLine(args);
    //.AddEnvironmentVariables("TestApp_");

var app = builder.Build();

foreach (var a in args) Console.WriteLine("ENV: " + a);

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
