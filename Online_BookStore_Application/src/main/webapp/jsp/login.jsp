<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Login Modal</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
body {
	height: 100vh;
}

.modal-content {
	border-radius: 20px;
}

.modal-header {
	background: #212529;
	color: white;
}

.login-icon {
	font-size: 70px;
	color: #0d6efd;
}
</style>

</head>

<body>

	<!-- LOGIN MODAL -->

	<div class="modal fade" id="loginModal" tabindex="-1"
		aria-hidden="true">

		<div class="modal-dialog modal-dialog-centered">

			<div class="modal-content shadow-lg border-0 rounded-4">

				<!-- MODAL HEADER -->

				<div class="modal-header bg-dark text-white">

					<h4 class="modal-title">📚 Online Book Store Login</h4>

					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>

				</div>

				<!-- MODAL BODY -->

				<div class="modal-body p-4">

					<div class="text-center mb-4">

						<i class="fa-solid fa-circle-user
fa-4x text-primary"></i>

					</div>

					<form action="${pageContext.request.contextPath}/LoginServlet"
						method="post">

						<!-- EMAIL -->

						<div class="mb-3">

							<label class="form-label"> Email </label> <input type="email"
								name="email" class="form-control form-control-lg"
								placeholder="Enter Email" required>

						</div>

						<!-- PASSWORD -->

						<div class="mb-3">

							<label class="form-label"> Password </label> <input
								type="password" id="password" name="password"
								class="form-control form-control-lg"
								placeholder="Enter Password" required>

						</div>

						<!-- SHOW PASSWORD -->

						<div class="form-check mb-3">

							<input class="form-check-input" type="checkbox" id="showPassword">

							<label class="form-check-label" for="showPassword"> Show
								Password </label>

						</div>

						<!-- LOGIN BUTTON -->

						<div class="d-grid">

							<button type="submit" class="btn btn-primary btn-lg">

								<i class="fa-solid fa-right-to-bracket"></i> Login

							</button>

						</div>

						<!-- REGISTER LINK -->

						<div class="text-center mt-3">

							<a href="register.jsp" class="text-decoration-none"> Create
								New Account </a>

						</div>

					</form>

					<!-- ERROR MESSAGE -->

					<%
					String msg = (String) request.getAttribute("error");

					if (msg != null) {
					%>

					<div class="alert alert-danger mt-3">

						<%=msg%>

					</div>

					<%
					}
					%>

				</div>

			</div>

		</div>

	</div>

	<!-- BOOTSTRAP JS -->

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
		
	</script>

	<!-- AUTO OPEN MODAL -->

	<script>
		window.onload = function() {

			const loginModal = new bootstrap.Modal(document
					.getElementById('loginModal'));

			loginModal.show();
		};
	</script>

	<!-- SHOW PASSWORD -->

	<script>
		const showPassword = document.getElementById("showPassword");

		const password = document.getElementById("password");

		showPassword.addEventListener("change", function() {

			if (this.checked) {

				password.type = "text";

			} else {

				password.type = "password";
			}
		});
		
		
		window.onload = function(){

		    const loginModalElement =
		    document.getElementById(
		        'loginModal'
		    );

		    const loginModal =
		    new bootstrap.Modal(
		        loginModalElement
		    );

		    // OPEN MODAL

		    loginModal.show();

		    // WHEN MODAL CLOSES

		    loginModalElement.addEventListener(
		    'hidden.bs.modal',
		    function () {

		        window.location.href =
		        'Main-Dashboard.jsp';

		    });

		};
	</script>

</body>
</html>




