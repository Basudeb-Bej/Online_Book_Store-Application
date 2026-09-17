<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Register Modal</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
body {
	height: 100vh;
	background: #f5f5f5;
}

.modal-content {
	border-radius: 20px;
	overflow: hidden;
}

.modal-header {
	background: linear-gradient(90deg, #4caf50, #2e7d32);
	color: white;
}

.reg-icon {
	font-size: 70px;
	color: #198754;
}
</style>

</head>

<body>

	<!-- REGISTER MODAL -->

	<div class="modal fade" id="registerModal" tabindex="-1"
		aria-hidden="true">

		<div class="modal-dialog modal-dialog-centered">

			<div class="modal-content shadow-lg border-0">

				<!-- MODAL HEADER -->

				<div class="modal-header">

					<h4 class="modal-title">📚 Create Account</h4>

					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>

				</div>

				<!-- MODAL BODY -->

				<div class="modal-body p-4">

					<div class="text-center mb-4">

						<i class="fa-solid fa-user-plus
reg-icon"></i>

					</div>

					<form action="${pageContext.request.contextPath}/RegisterServlet"
						method="post">

						<!-- NAME -->

						<div class="mb-3">

							<label class="form-label"> Full Name </label> <input type="text"
								name="name" class="form-control form-control-lg"
								placeholder="Enter Full Name" required>

						</div>

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

						<!-- CONFIRM PASSWORD -->

						<div class="mb-3">

							<label class="form-label"> Re-enter Password </label> <input
								type="password" id="confirmPassword" name="confirmPassword"
								class="form-control form-control-lg"
								placeholder="Re-enter Password" required>

						</div>

						<!-- SHOW PASSWORD -->

						<div class="form-check mb-3">

							<input class="form-check-input" type="checkbox" id="showPassword">

							<label class="form-check-label" for="showPassword"> Show
								Password </label>

						</div>

						<!-- REGISTER BUTTON -->

						<div class="d-grid">

							<button type="submit" class="btn btn-success btn-lg">

								<i class="fa-solid fa-user-check"></i> Register

							</button>

						</div>

						<!-- LOGIN LINK -->

						<div class="text-center mt-3">

							<a href="login.jsp" class="text-decoration-none"> Already
								have an account? Login </a>

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

			const registerModalElement = document
					.getElementById('registerModal');

			const registerModal = new bootstrap.Modal(registerModalElement);

			// OPEN MODAL

			registerModal.show();

			// REDIRECT WHEN CLOSED

			registerModalElement.addEventListener('hidden.bs.modal',
					function() {

						window.location.href = 'Main-Dashboard.jsp';

					});

		};
	</script>

	<!-- SHOW PASSWORD -->

	<script>
		const showPassword = document.getElementById("showPassword");

		const password = document.getElementById("password");

		const confirmPassword = document.getElementById("confirmPassword");

		showPassword.addEventListener("change", function() {

			if (this.checked) {

				password.type = "text";

				confirmPassword.type = "text";

			} else {

				password.type = "password";

				confirmPassword.type = "password";
			}

		});
	</script>

	<script>
		const form = document.querySelector("form");

		form.addEventListener("submit",
				function(e) {

					const password = document.getElementById("password").value;

					const confirmPassword = document
							.getElementById("confirmPassword").value;

					if (password !== confirmPassword) {

						e.preventDefault();

						alert("Passwords do not match");

					}

				});
	</script>

</body>
</html>