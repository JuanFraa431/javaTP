<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String nombre = (String) session.getAttribute("nombre");
  if (nombre == null || nombre.isBlank()) nombre = "Detective";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Tutorial — Misterio en la Mansión</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root{
      --bg1:#070a10; --bg2:#0f1a2b; --text:#e9eef8; --muted:#a6b3c7;
      --accent:#f7b733; --accent2:#ff7a18;
      --glass:rgba(14,20,32,.55); --edge:rgba(255,255,255,.12);
      --radius:16px; --shadow:0 18px 45px rgba(0,0,0,.55); --blur:12px;
    }
    *{ box-sizing:border-box; margin:0; padding:0; }
    html,body{ height:100% }
    body{
      margin:0; color:var(--text);
      font-family:'Nunito',system-ui,-apple-system,Segoe UI,Roboto,sans-serif;
      background: radial-gradient(1200px 600px at 20% 10%, rgba(255,255,255,.03), transparent 60%),
                  linear-gradient(135deg, var(--bg1), var(--bg2) 60%);
      -webkit-font-smoothing:antialiased;
    }
    .container{
      min-height:100vh;
      padding:clamp(16px,3vw,36px);
      max-width:1000px;
      margin:0 auto;
    }
    .header{
      text-align:center;
      margin:20px 0 50px;
    }
    .header h1{
      font-family:'Creepster',cursive;
      font-size:clamp(2rem,4.2vw,3.2rem);
      color:#f2f4ff;
      text-shadow:0 0 18px rgba(247,183,51,.15), 0 2px 0 rgba(0,0,0,.6);
      margin:0 0 10px;
      letter-spacing:.4px;
    }
    .header p{
      color:var(--muted);
      font-weight:800;
      letter-spacing:.3px;
    }
    .back-btn{
      display:inline-flex; align-items:center; gap:8px;
      padding:12px 16px; border-radius:12px;
      background:transparent; color:var(--text);
      border:1px dashed var(--edge);
      text-decoration:none; font-weight:900; letter-spacing:.3px;
      box-shadow:0 12px 26px rgba(0,0,0,.28), inset 0 0 0 1px rgba(255,255,255,.25);
      transition:transform .08s, box-shadow .18s, filter .18s;
      margin-bottom:30px;
    }
    .back-btn:hover{
      transform:translateY(-1px);
      filter:brightness(1.05);
    }
    .section{
      background:var(--glass);
      border:1px solid var(--edge);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      backdrop-filter:blur(var(--blur)) saturate(120%);
      padding:30px;
      margin-bottom:24px;
      transition:transform .15s ease, box-shadow .25s ease, border-color .25s ease;
    }
    .section:hover{
      transform:translateY(-2px);
      border-color:rgba(255,255,255,.18);
      box-shadow:0 22px 55px rgba(0,0,0,.55);
    }
    .section-title{
      font-size:1.6em;
      color:color-mix(in oklab, var(--accent), white 10%);
      margin:0 0 20px;
      font-weight:800;
      letter-spacing:.3px;
      display:flex;
      align-items:center;
      gap:12px;
    }
    .section-title i{
      display:inline-grid;
      place-items:center;
      width:40px; height:40px;
      border-radius:10px;
      background:rgba(255,255,255,.06);
      box-shadow:inset 0 0 0 1px rgba(255,255,255,.15);
    }
    .section-content{
      line-height:1.8;
      color:#d5deee;
    }
    .section-content p{
      margin:0 0 15px;
    }
    .steps{
      list-style:none;
      counter-reset:step-counter;
      padding:0;
    }
    .steps li{
      counter-increment:step-counter;
      margin-bottom:20px;
      padding-left:60px;
      position:relative;
    }
    .steps li::before{
      content:counter(step-counter);
      position:absolute;
      left:0; top:0;
      width:40px; height:40px;
      background:linear-gradient(180deg, color-mix(in oklab, var(--accent), white 10%), var(--accent2));
      border-radius:50%;
      display:grid;
      place-items:center;
      font-weight:900;
      color:#0a0f18;
      font-size:1.1em;
      box-shadow:0 4px 10px rgba(247,183,51,.3);
    }
    .tips{
      background:rgba(247,183,51,.08);
      border-left:4px solid var(--accent);
      padding:20px;
      border-radius:8px;
      margin-top:20px;
    }
    .tips-title{
      font-weight:900;
      color:var(--accent);
      margin-bottom:12px;
      display:flex;
      align-items:center;
      gap:10px;
    }
    .tips ul{
      list-style:none;
      padding:0;
    }
    .tips li{
      padding-left:30px;
      position:relative;
      margin-bottom:10px;
      color:#d5deee;
    }
    .tips li::before{
      content:'→';
      position:absolute;
      left:0; top:0;
      color:var(--accent);
      font-weight:900;
    }
    .highlight{
      color:var(--accent);
      font-weight:700;
    }
    .kbd{
      display:inline-block;
      padding:4px 8px;
      background:rgba(255,255,255,.06);
      border:1px solid rgba(255,255,255,.12);
      border-radius:6px;
      font-family:monospace;
      font-size:.9em;
      color:var(--accent);
    }
    @media (max-width: 768px){
      .section{ padding:20px; }
      .section-title{ font-size:1.3em; }
      .steps li{ padding-left:50px; }
      .steps li::before{ width:35px; height:35px; font-size:1em; }
    }
  </style>
</head>
<body>
  <div class="container">
    <a href="<%=ctx%>/jugador/home" class="back-btn">
      <i class="fa-solid fa-arrow-left"></i>
      Volver al inicio
    </a>

    <div class="header">
      <h1>Tutorial del Detective</h1>
      <p>Aprendé a resolver los misterios más oscuros</p>
    </div>

    <!-- Sección 1: Cómo empezar -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-flag-checkered"></i>
        Cómo Empezar
      </h2>
      <div class="section-content">
        <ol class="steps">
          <li>
            <strong>Seleccioná una Historia</strong><br>
            Desde el inicio, hacé clic en <span class="highlight">"Historias"</span> o 
            <span class="highlight">"Nueva partida"</span> para elegir un caso.
          </li>
          <li>
            <strong>Iniciá la Investigación</strong><br>
            Una vez seleccionada, la partida se crea automáticamente y comenzás en la primera ubicación.
          </li>
          <li>
            <strong>Interactuá con el Detective Virtual</strong><br>
            Tu compañero IA te guiará con pistas y sugerencias. Usá las respuestas rápidas para avanzar.
          </li>
        </ol>
      </div>
    </div>

    <!-- Sección 2: Documentos -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-folder-open"></i>
        Los Documentos
      </h2>
      <div class="section-content">
        <p>
          Durante el juego, encontrarás <span class="highlight">documentos clave</span> que contienen 
          pistas esenciales para resolver el caso.
        </p>
        <ol class="steps">
          <li>
            <strong>Acceder a los Documentos</strong><br>
            Hacé clic en el botón <span class="kbd"><i class="fa-regular fa-folder-open"></i> Documentos</span> 
            en la parte superior de la pantalla del juego.
          </li>
          <li>
            <strong>Leer con Atención</strong><br>
            Cada documento (cartas, notas, correos) contiene información crucial. 
            Buscá <span class="highlight">códigos, nombres, fechas</span> y cualquier detalle sospechoso.
          </li>
          <li>
            <strong>Conectar las Pistas</strong><br>
            Relacioná la información de diferentes documentos. A menudo, la respuesta está en los detalles.
          </li>
        </ol>

        <div class="tips">
          <div class="tips-title">
            <i class="fa-solid fa-lightbulb"></i>
            Consejos Pro
          </div>
          <ul>
            <li>Leé todos los documentos antes de ingresar el código</li>
            <li>Prestá atención a los nombres y las horas mencionadas</li>
            <li>Algunos códigos pueden estar "escondidos" en formato de fechas o iniciales</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Sección 3: Chat y Pistas -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-comments"></i>
        Chat y Pistas
      </h2>
      <div class="section-content">
        <p>
          El <span class="highlight">Detective Virtual</span> es tu aliado. Usá las opciones de chat para:
        </p>
        <ol class="steps">
          <li>
            <strong>"Repasá el caso"</strong><br>
            Te da un resumen de los hechos principales para refrescar tu memoria.
          </li>
          <li>
            <strong>"Dame una pista"</strong><br>
            Te orienta hacia dónde buscar o qué documentos revisar.
          </li>
          <li>
            <strong>"Descubrí algo importante"</strong><br>
            Cuando estés listo para revelar el código secreto y resolver el caso.
          </li>
        </ol>
      </div>
    </div>

    <!-- Sección 4: Resolver el Caso -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-lock-open"></i>
        Resolver el Caso
      </h2>
      <div class="section-content">
        <p>
          Para resolver el misterio, necesitás descifrar el <span class="highlight">código secreto</span>.
        </p>
        <ol class="steps">
          <li>
            <strong>Encontrá el Código</strong><br>
            Está oculto en los documentos. Puede ser una combinación de letras, números o nombres.
          </li>
          <li>
            <strong>Ingresá el Código</strong><br>
            Cuando lo tengas, decile al detective que <span class="highlight">"Descubrí algo importante"</span>
            y luego seleccioná <span class="highlight">"Encontré el código secreto"</span>.
          </li>
          <li>
            <strong>Finalizá la Partida</strong><br>
            Si el código es correcto, se revelará al culpable y podrás finalizar la partida con tu puntuación.
          </li>
        </ol>

        <div class="tips">
          <div class="tips-title">
            <i class="fa-solid fa-exclamation-triangle"></i>
            Importante
          </div>
          <ul>
            <li>Tenés un número limitado de intentos, así que pensá bien antes de ingresar el código</li>
            <li>Si ingresás un código incorrecto, podés volver a intentar pero perdés puntos</li>
            <li>Una vez finalizada, la partida queda registrada en <span class="highlight">"Mis Partidas"</span></li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Sección 5: Progreso y Estadísticas -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-chart-line"></i>
        Progreso y Estadísticas
      </h2>
      <div class="section-content">
        <p>
          En la sección <span class="highlight">"Mis Partidas"</span> podés ver:
        </p>
        <ul class="steps">
          <li><strong>Pistas Encontradas:</strong> Cuántas pistas descubriste en cada partida</li>
          <li><strong>Lugares Explorados:</strong> Cuántas ubicaciones visitaste</li>
          <li><strong>Puntuación:</strong> Tu desempeño en cada caso</li>
          <li><strong>Estado:</strong> Si está en progreso, ganada o perdida</li>
        </ul>

        <p style="margin-top: 20px;">
          <span class="highlight">¡Cada detalle cuenta!</span> 
          Cuantas más pistas encuentres y menos intentos uses, mejor será tu puntuación final.
        </p>
      </div>
    </div>

    <!-- Sección 6: Consejos Finales -->
    <div class="section">
      <h2 class="section-title">
        <i class="fa-solid fa-star"></i>
        Consejos de Expertos
      </h2>
      <div class="section-content">
        <div class="tips">
          <ul>
            <li>Jugá con paciencia: los mejores detectives no se apuran</li>
            <li>Tomá notas (en papel o mental) de los detalles importantes</li>
            <li>Revisá todos los documentos antes de intentar resolver</li>
            <li>Si te trabás, pedí una pista al detective virtual</li>
            <li>La atmósfera del juego es importante: jugá en un lugar tranquilo 🌙</li>
            <li>Recordá: cada historia tiene una única solución correcta</li>
          </ul>
        </div>
      </div>
    </div>

    <div style="text-align: center; margin-top: 50px;">
      <a href="<%=ctx%>/jugador/home" class="back-btn" style="font-size: 1.1em; padding: 15px 30px;">
        <i class="fa-solid fa-house"></i>
        Volver al Inicio
      </a>
    </div>
  </div>
</body>
</html>
