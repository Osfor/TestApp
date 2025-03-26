var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

//reads docker run args and overrides settings
builder.Configuration
    .AddJsonFile("appsettings.json")
    .AddEnvironmentVariables("TestApp_");

foreach (var a in args) Console.WriteLine("ENV: " + a);

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
