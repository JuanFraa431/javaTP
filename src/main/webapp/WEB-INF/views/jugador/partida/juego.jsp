<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    String ctx = request.getContextPath();
    String nombre = (String) session.getAttribute("nombre");
    if (nombre == null || nombre.isBlank()) nombre = "Detective";

    entities.Partida partida = (entities.Partida) request.getAttribute("partida");
    entities.Historia historia = (entities.Historia) request.getAttribute("historia");
    Integer partidaId = (Integer) session.getAttribute("partidaId");
    
    @SuppressWarnings("unchecked")
    List<entities.Documento> documentos = (List<entities.Documento>) request.getAttribute("documentos");
    if (documentos == null) documentos = java.util.Collections.emptyList();
    
    // Obtener el documento con código correcto
    String codigoCorrecto = "";
    String pistaNombre = "";
    for (entities.Documento doc : documentos) {
        if (doc.getCodigoCorrecto() != null && !doc.getCodigoCorrecto().isEmpty()) {
            codigoCorrecto = doc.getCodigoCorrecto();
            pistaNombre = doc.getPistaNombre() != null ? doc.getPistaNombre() : "Pista principal";
            break;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title><%= historia != null ? historia.getTitulo() : "Misterio en la Mansión" %> — Caso en curso</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="<%=ctx%>/style/juego.css">
</head>
<body>

<!-- Botón y panel de Documentos -->
<div class="docs">
    <button id="btnDocs" class="btn btn-secondary">
        <i class="fa-regular fa-folder-open"></i> Documentos
    </button>

    <div id="docsPanel" class="docs-panel" hidden>
        <% for (entities.Documento doc : documentos) { %>
        <button class="doc" data-doc="<%= doc.getClave() %>">
            <i class="<%= doc.getIcono() %>"></i>
            <%= doc.getNombre() %>
        </button>
        <% } %>
    </div>
</div>

<!-- Modal documento -->
<div id="docModal" class="modal" hidden>
    <div class="modal-card" role="dialog" aria-modal="true" aria-label="Documento">
        <button class="close" id="closeDoc" aria-label="Cerrar documento">
            <i class="fa-solid fa-xmark"></i>
        </button>
        <div id="docContent"></div>
    </div>
</div>

<!-- Contenedor del chat -->
<main class="chat-wrap">
    <header class="chat-head">
        <h1 class="title"><%= historia != null ? historia.getTitulo() : "Misterio en la Mansión" %></h1>
        <p class="subtitle">
            Detective virtual:
            <em>"Estoy listo. Hacé tus preguntas y te guío".</em>
        </p>

        <% if (partida != null) { %>
        <div style="font-size:0.9em; color:#999; margin-top:8px;">
            Pistas encontradas: <%= partida.getPistasEncontradas() %> |
            Puntuación: <%= partida.getPuntuacion() %>
        </div>
        <% } %>
    </header>

    <section id="thread" class="thread" aria-live="polite" aria-label="Conversación"></section>

    <!-- Quick replies -->
    <div id="replies" class="replies"></div>

    <!-- Entrada de código -->
    <form id="codeForm" class="code-form" hidden>
        <input type="text" id="codeInput" placeholder="Ingresá el código…" autocomplete="off" />
        <button type="submit" class="btn btn-primary">
            <i class="fa-solid fa-paper-plane"></i> Enviar
        </button>
    </form>
</main>

<script>
    const ctx = '<%=ctx%>';
    const partidaId = <%= partidaId != null ? partidaId : -1 %>;

    /* ================== Helpers de UI ================== */
    const $        = sel => document.querySelector(sel);
    const thread   = $('#thread');
    const replies  = $('#replies');
    const codeForm = $('#codeForm');
    const codeInput= $('#codeInput');

    function scrollBottom() {
        thread.scrollTop = thread.scrollHeight;
    }

    function isHTML(s) {
        return /<\/?[a-z][\s\S]*>/i.test(s);
    }

    // Inserta burbuja y garantiza que quede texto visible
    function bubble(role, text, opts = {}) {
        const msg = document.createElement('div');
        msg.className = `msg ${role}`;

        const b = document.createElement('div');
        b.className = 'bubble';

        const safeText = (text ?? '').toString();

        // Si enviaste HTML (bot), lo renderizamos; si no, como texto plano
        if (isHTML(safeText)) {
            b.innerHTML = safeText;
        } else {
            b.textContent = safeText || '…';
        }

        msg.appendChild(b);
        thread.appendChild(msg);
        scrollBottom();

        // (Opcional) máquina de escribir — desactivada por defecto
        if (opts.typewriter) {
            const full = isHTML(safeText) ? b.textContent : safeText;
            b.textContent = '';
            let i = 0;
            const id = setInterval(() => {
                if (i < full.length) {
                    b.textContent += full[i++];
                    thread.scrollTop = thread.scrollHeight;
                } else {
                    clearInterval(id);
                    if (!b.textContent) b.textContent = full;
                }
            }, opts.speed || 16);
        }

        return b;
    }

    const bot = (t, opts) => bubble('bot', t, opts);
    const me  = (t, opts) => bubble('me',  t, opts);

    function setReplies(buttons) {
        replies.innerHTML = '';
        (buttons || []).forEach(b => {
            const el = document.createElement('button');
            el.type = 'button';
            el.className = 'qr';
            el.textContent = b.label;
            el.addEventListener('click', b.onClick);
            replies.appendChild(el);
        });
    }

    /* ================== Documentos ================== */
    const btnDocs    = $('#btnDocs');
    const docsPanel  = $('#docsPanel');
    const docModal   = $('#docModal');
    const docContent = $('#docContent');
    const closeDoc   = $('#closeDoc');

    // aseguramos ocultos al cargar
    docsPanel.hidden = true;
    docModal.hidden  = true;

    // Cargar documentos desde el servidor
    const documentos = [
        <% for (int i = 0; i < documentos.size(); i++) {
            entities.Documento doc = documentos.get(i);
        %>
        {
            clave: '<%= doc.getClave() %>',
            nombre: '<%= doc.getNombre().replace("'", "\\'") %>',
            icono: '<%= doc.getIcono() %>',
            contenido: `<%= doc.getContenido().replace("`", "\\`").replace("\n", " ") %>`
        }<%= i < documentos.size() - 1 ? "," : "" %>
        <% } %>
    ];

    btnDocs.addEventListener('click', () => {
        docsPanel.hidden = !docsPanel.hidden;
    });

    // cerrar panel al clickear afuera
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.docs')) docsPanel.hidden = true;
    });

    // abrir documento
    document.querySelectorAll('.doc').forEach(btn => {
        btn.addEventListener('click', () => {
            docsPanel.hidden = true;
            const clave = btn.dataset.doc;
            const documento = documentos.find(d => d.clave === clave);
            
            if (documento) {
                docContent.innerHTML = documento.contenido;
                docModal.hidden = false;
            }
        });
    });

    // cerrar modal
    closeDoc.addEventListener('click', () => docModal.hidden = true);
    docModal.addEventListener('click', (e) => {
        if (e.target === docModal) docModal.hidden = true;
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !docModal.hidden) docModal.hidden = true;
    });

    /* ================== Flujo del chat ================== */
    const CODE_OK = '<%= codigoCorrecto %>';
    const PISTA_NOMBRE = '<%= pistaNombre %>';
    let awaitingCode = false;

    function inicio() {
        setReplies([]);
        bot(`Bienvenido, <strong><%=nombre%></strong>. Soy tu compañero virtual.`);
        bot(`Estoy listo para ayudarte. Podés pedirme: <em>"Repasá el caso"</em>, <em>"Dame una pista"</em> o <em>"Descubrí algo importante"</em>.`);

        setReplies([
            {
                label: 'Repasá el caso',
                onClick: () => {
                    me('Repasá el caso');
                    bot('Víctima en el estudio. Varios posibles motivos. Revisá los documentos para pistas.');
                }
            },
            {
                label: 'Dame una pista',
                onClick: () => {
                    me('Dame una pista');
                    bot('Revisá los documentos con atención. Ahí están las claves para resolver el caso.');
                }
            },
            {
                label: 'Descubrí algo importante',
                onClick: descubriAlgo
            }
        ]);
    }

    function descubriAlgo() {
        me('Descubrí algo importante');
        bot('¿Qué descubriste?');
        setReplies([
            { label: 'Encontré el código secreto', onClick: descubriCodigo },
            { label: 'Mejor, volvamos al inicio', onClick: () => { me('Volvamos'); inicio(); } }
        ]);
    }

    function descubriCodigo() {
        me('Encontré el código secreto');
        bot('Excelente. ¿Cuál es el código? Ingresalo abajo.');
        awaitingCode = true;
        setReplies([]);
        codeForm.hidden = false;
        codeInput.value = '';
        codeInput.focus();
    }

    codeForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const value = (codeInput.value || '').trim();
        if (!value) return;

        me(value);
        codeInput.value = '';

        if (!awaitingCode) {
            bot('No estoy esperando un código ahora. Probá con las opciones de abajo.');
            return;
        }

        if (value.replace(/\s+/g, '') === CODE_OK) {
            codeForm.hidden = true;
            awaitingCode = false;

            // Guardar la pista usando ChatServlet
            try {
                const formData = new URLSearchParams();
                formData.append('action', 'validate_code');
                formData.append('code', CODE_OK);
                
                const response = await fetch(ctx + '/jugador/partidas/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                });
                const data = await response.json();
                
                if (data.ok) {
                    bot('¡Exacto! Código correcto. 💻');
                    bot('Las pruebas son contundentes. <strong>¡Descubrimos al culpable!</strong> 🕵️‍♂️');
                    bot('Caso resuelto con éxito. Podés finalizar la partida ahora.');
                    
                    // Mostrar botón de finalizar partida
                    const finForm = document.createElement('form');
                    finForm.method = 'post';
                    finForm.action = ctx + '/jugador/partidas/finalizar';
                    finForm.style.textAlign = 'center';
                    finForm.style.marginTop = '20px';
                    finForm.innerHTML = `
                        <input type="hidden" name="pid" value="${partidaId}">
                        <button class="btn btn-primary" type="submit" style="font-size:1.1em; padding:12px 24px;">
                            <i class="fa-solid fa-flag-checkered"></i> Finalizar Partida
                        </button>
                    `;
                    replies.innerHTML = '';
                    replies.appendChild(finForm);
                } else {
                    bot('Error inesperado. Pero el código era correcto.');
                }
            } catch (e) {
                console.error('Error al validar código:', e);
                bot('¡Exacto! Código correcto.');
                bot('Caso resuelto con éxito. Podés finalizar la partida ahora.');
                
                // Mostrar botón de finalizar de todas formas
                const finForm = document.createElement('form');
                finForm.method = 'post';
                finForm.action = ctx + '/jugador/partidas/finalizar';
                finForm.style.textAlign = 'center';
                finForm.style.marginTop = '20px';
                finForm.innerHTML = `
                    <input type="hidden" name="pid" value="${partidaId}">
                    <button class="btn btn-primary" type="submit" style="font-size:1.1em; padding:12px 24px;">
                        <i class="fa-solid fa-flag-checkered"></i> Finalizar Partida
                    </button>
                `;
                replies.innerHTML = '';
                replies.appendChild(finForm);
            }
        } else {
            // Código incorrecto
            bot('Mmm… no coincide. Revisá la nota y el correo. Intentá nuevamente.');
            setReplies([
                { label: 'Volver a ingresar el código', onClick: () => { descubriCodigo(); } },
                { label: 'Volver al inicio', onClick: () => { codeForm.hidden = true; awaitingCode = false; inicio(); } }
            ]);
        }
    });

    inicio();
</script>
</body>
</html>
