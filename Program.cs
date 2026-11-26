
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new
{
    status = "Healthy",
    application = "CloudOps Portal",
    timestamp = DateTime.UtcNow
}));

app.MapPost("/api/deploy", () => Results.Ok(new
{
    success = true,
    message = "Deployment test successful!"
}));

app.MapGet("/", () => Results.Content("""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CloudOps | Dashboard</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:Segoe UI,Arial;background:#0b1120;color:#f8fafc}
.layout{display:flex;min-height:100vh}
aside{width:235px;background:#111827;padding:30px 20px;border-right:1px solid #263247}
.logo{font-size:25px;font-weight:800;color:#60a5fa;margin-bottom:45px}
.logo span{color:white}
.menu-title{font-size:11px;color:#64748b;letter-spacing:2px;margin-bottom:15px}
nav a{display:block;padding:14px;margin:7px 0;border-radius:8px;text-decoration:none;color:#cbd5e1}
nav a.active,nav a:hover{background:#1e3a5f;color:#60a5fa}
main{flex:1;padding:35px}
header{display:flex;justify-content:space-between;align-items:center;margin-bottom:35px;gap:15px}
header p,.muted{color:#94a3b8;font-size:13px;margin-top:7px}
.profile{background:#1e293b;padding:12px 18px;border-radius:25px;font-size:13px}
.hero{padding:38px;background:linear-gradient(120deg,#123d70,#1d4ed8,#4338ca);border-radius:17px;margin-bottom:30px}
.hero h1{font-size:30px;margin-bottom:12px}
.hero p{color:#dbeafe;line-height:1.7}
.tag{display:inline-block;margin-top:18px;padding:8px 13px;background:#ffffff22;border-radius:20px;font-size:12px}
h3{margin:25px 0 17px}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:17px}
.card,.panel{background:#151f31;border:1px solid #263247;border-radius:13px;padding:23px}
.card small{color:#94a3b8}
.card h2{font-size:26px;margin:15px 0 8px}
.green{color:#4ade80}.blue{color:#60a5fa}.purple{color:#c4b5fd}
.content{display:grid;grid-template-columns:1.4fr 1fr;gap:17px}
.service{display:flex;justify-content:space-between;gap:10px;padding:15px 0;border-bottom:1px solid #263247;font-size:13px;color:#cbd5e1}
button{margin-top:20px;width:100%;padding:14px;background:#2563eb;border:0;border-radius:8px;color:white;font-weight:bold;cursor:pointer}
button:hover{background:#1d4ed8}
#result{font-size:13px;margin-top:15px;color:#4ade80}
footer{text-align:center;color:#64748b;margin-top:35px;font-size:12px}
@media(max-width:850px){.cards{grid-template-columns:1fr 1fr}.content{grid-template-columns:1fr}}
@media(max-width:600px){aside{display:none}main{padding:18px}.cards{grid-template-columns:1fr}.hero h1{font-size:23px}}
</style>
</head>
<body>
<div class="layout">
<aside>
<div class="logo">Cloud<span>Ops.</span></div>
<div class="menu-title">WORKSPACE</div>
<nav>
<a class="active" href="#">◈ Dashboard</a>
<a href="#services">▣ Services</a>
<a href="#infrastructure">◉ Infrastructure</a>
<a href="#deployment">⇧ Deployment</a>
</nav>
</aside>

<main>
<header>
<div>
<h2>Dashboard Overview</h2>
<p>Monitor and manage your cloud environment</p>
</div>
<div class="profile">● Admin Workspace</div>
</header>

<section class="hero">
<h1>Welcome to CloudOps Control Center 👋</h1>
<p>Manage your cloud infrastructure, monitor services and deploy applications from one central dashboard.</p>
<span class="tag">● ASP.NET Core | Cloud Environment</span>
</section>

<h3>Infrastructure Summary</h3>
<section class="cards">
<div class="card">
<small>Compute Platform</small>
<h2 class="blue">Windows</h2>
<span class="green">● IIS Ready</span>
</div>
<div class="card">
<small>Application</small>
<h2 class="purple">ASP.NET</h2>
<span class="green">● Running</span>
</div>
<div class="card">
<small>Deployment</small>
<h2 class="green">CI/CD</h2>
<span class="green">● GitHub Actions</span>
</div>
</section>

<h3 id="infrastructure">Cloud Infrastructure</h3>
<section class="content" id="services">
<div class="panel">
<h3>Service Overview</h3>
<div class="service"><span>Windows EC2</span><span class="green">Configured</span></div>
<div class="service"><span>IIS Web Server</span><span class="green">Ready</span></div>
<div class="service"><span>Application Load Balancer</span><span class="blue">Planned</span></div>
<div class="service"><span>Auto Scaling Group</span><span class="blue">Planned</span></div>
<div class="service"><span>Terraform</span><span class="green">Ready</span></div>
</div>

<div class="panel" id="deployment">
<h3>Deployment Center</h3>
<p class="muted">Test the application backend and verify connectivity.</p>
<button onclick="deploy()">Test Application</button>
<div id="result"></div>
</div>
</section>

<footer>© 2026 CloudOps Control Center | Built with ASP.NET Core</footer>
</main>
</div>

<script>
async function deploy(){
 const result=document.getElementById('result');
 result.innerText='Testing backend...';
 try{
  const response=await fetch('/api/deploy',{method:'POST'});
  const data=await response.json();
  result.innerText=data.message;
 }catch(e){
  result.innerText='Backend connection failed';
 }
}
</script>
</body>
</html>
""", "text/html"));

app.Run();
