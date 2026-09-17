<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Admin Profile</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">

<style>
body {
	background: #f5f5f5;
}

.sidebar {
	position: fixed;
	top: 0;
	left: 0;
	width: 18.75rem;
	height: 100vh;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	background: #212529;
	color: white;
	padding: 18px 16px;
	z-index: 1030;
}

.sidebar a {
	color: white;
	text-decoration: none;
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 12px 14px;
	border-radius: 10px;
	margin-bottom: 6px;
	font-weight: 500;
}

.sidebar a:hover {
	background: #343a40;
}

.sidebar-menu {
	flex: 1;
	overflow-y: auto;
	padding-right: 4px;
}

.sidebar-footer {
	background: rgba(255, 255, 255, 0.08);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 16px;
	padding: 16px;
	margin-top: 14px;
}

.profile-avatar {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	object-fit: cover;
	border: 3px solid rgba(255, 255, 255, 0.15);
}

.page-wrap {
	padding-left: 20.5rem;
	padding-right: 1.5rem;
}

.admin-main {
	padding-left: 1.5rem !important;
	padding-right: 0 !important;
}

.card {
	border: none;
	border-radius: 15px;
}

.profile-card, .summary-card {
	border-radius: 18px;
}

.min-w-0 {
	min-width: 0;
}

@media ( max-width : 767.98px) {
	.sidebar {
		position: static;
		width: 100%;
		height: auto;
		overflow: visible;
	}
	.page-wrap {
		padding-left: 0;
		padding-right: 0;
	}
}
</style>

<script>
function confirmLogout(){
    return confirm('Are you sure you want to logout?');
}
</script>

</head>
<body>

	<%
String role = (String) session.getAttribute("role");
if(role == null || !role.equals("admin")){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
%>

	<c:set var="profile" value="${requestScope.profile}" />

	<c:set var="profileImageUrl" value="" />
	<c:if test="${not empty profile and not empty profile.image}">
		<c:choose>
			<c:when
				test="${fn:startsWith(profile.image, 'http://') or fn:startsWith(profile.image, 'https://') or fn:startsWith(profile.image, '/')}">
				<c:set var="profileImageUrl" value="${profile.image}" />
			</c:when>
			<c:when test="${fn:startsWith(profile.image, 'images/')}">
				<c:set var="profileImageUrl"
					value="${pageContext.request.contextPath}/${profile.image}" />
			</c:when>
			<c:otherwise>
				<c:url var="profileImageUrl" value="/images/${profile.image}" />
			</c:otherwise>
		</c:choose>
	</c:if>


	<div class="container-fluid page-wrap">

		<div class="row">

			<div class="col-md-2 sidebar">

				<!-- div class="d-flex align-items-center mb-4 gap-3">
        <div class="rounded-circle bg-light text-dark d-flex align-items-center justify-content-center" style="width:52px;height:52px;flex:0 0 auto;">
            <i class="bi bi-person-badge fs-3"></i>
        </div>
        <div class="min-w-0">
            <h4 class="mb-0">Admin Panel</h4>
            <small class="text-white-50">Profile settings</small>
        </div>
    </div-->

				<div class="sidebar-menu">
					<a href="${pageContext.request.contextPath}/AdminServlet"><i
						class="bi bi-speedometer2"></i>Dashboard</a> <a
						href="${pageContext.request.contextPath}/AdminServlet#addBook"><i
						class="bi bi-plus-circle"></i>Add Book</a> <a
						href="${pageContext.request.contextPath}/AdminServlet#bookList"><i
						class="bi bi-journal-bookmark"></i>Manage Books</a> <a
						href="${pageContext.request.contextPath}/AdminProfileServlet"><i
						class="bi bi-person-lines-fill"></i>Profile</a> <a
						href="${pageContext.request.contextPath}/LogoutServlet"
						onclick="return confirmLogout();"><i
						class="bi bi-box-arrow-right"></i>Logout</a>
				</div>

				<div class="sidebar-footer">
					<div class="d-flex align-items-center gap-3">
						<c:choose>
							<c:when test="${not empty profileImageUrl}">
								<img class="profile-avatar" src="${profileImageUrl}"
									alt="${not empty profile.name ? profile.name : sessionScope.user}">
							</c:when>
							<c:otherwise>
								<div
									class="profile-avatar d-flex align-items-center justify-content-center bg-secondary bg-opacity-50">
									<i class="bi bi-person-circle fs-2"></i>
								</div>
							</c:otherwise>
						</c:choose>

						<div class="min-w-0">
							<div class="fw-semibold text-truncate">${not empty profile.name ? profile.name : sessionScope.user}
							</div>
							<div class="small text-white-50 text-truncate">${not empty profile.email ? profile.email : sessionScope.email}
							</div>
						</div>
					</div>
				</div>

			</div>

			<div class="col-md-10 p-4 admin-main">

				<div
					class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
					<div>
						<h2 class="mb-1">Admin Profile</h2>
						<div class="text-muted">Update your account details and
							profile image.</div>
					</div>
					<a href="${pageContext.request.contextPath}/AdminServlet"
						class="btn btn-outline-secondary"> <i
						class="bi bi-arrow-left me-1"></i>Back to Dashboard
					</a>
				</div>

				<c:if test="${not empty requestScope.error}">
					<div class="alert alert-danger">${requestScope.error}</div>
				</c:if>
				<c:if test="${not empty sessionScope.error}">
					<div class="alert alert-danger">${sessionScope.error}</div>
					<% session.removeAttribute("error"); %>
				</c:if>
				<c:if test="${not empty sessionScope.success}">
					<div class="alert alert-success">${sessionScope.success}</div>
					<% session.removeAttribute("success"); %>
				</c:if>

				<div class="row g-4">
					<div class="col-lg-4">
						<div class="card shadow-sm summary-card h-100">
							<div class="card-body text-center p-4">
								<c:choose>
									<c:when test="${not empty profileImageUrl}">
										<img src="${profileImageUrl}"
											alt="${not empty profile.name ? profile.name : sessionScope.user}"
											class="profile-avatar mb-3"
											style="width: 96px; height: 96px; border: 4px solid #fff; box-shadow: 0 8px 18px rgba(0, 0, 0, .12);">
									</c:when>
									<c:otherwise>
										<div
											class="profile-avatar mb-3 mx-auto d-flex align-items-center justify-content-center bg-light text-secondary"
											style="width: 96px; height: 96px; border: 4px solid #fff; box-shadow: 0 8px 18px rgba(0, 0, 0, .12);">
											<i class="bi bi-person-circle fs-1"></i>
										</div>
									</c:otherwise>
								</c:choose>

								<h4 class="mb-1">${not empty profile.name ? profile.name : sessionScope.user}</h4>
								<p class="text-muted mb-4">${not empty profile.email ? profile.email : sessionScope.email}</p>

								<div class="list-group text-start">
									<div
										class="list-group-item d-flex justify-content-between align-items-center">
										<span><i class="bi bi-envelope me-2"></i>Email</span> <span
											class="small text-muted text-end">${not empty profile.email ? profile.email : sessionScope.email}</span>
									</div>
									<div
										class="list-group-item d-flex justify-content-between align-items-center">
										<span><i class="bi bi-telephone me-2"></i>Phone</span> <span
											class="small text-muted text-end">${not empty profile.phone ? profile.phone : 'Not added'}</span>
									</div>
									<div
										class="list-group-item d-flex justify-content-between align-items-center">
										<span><i class="bi bi-geo-alt me-2"></i>Address</span> <span
											class="small text-muted text-end">${not empty profile.address ? profile.address : 'Not added'}</span>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-8">
						<div class="card shadow-sm profile-card">
							<div class="card-body p-4 p-lg-5">
								<h4 class="mb-4">
									<i class="bi bi-person-gear me-2"></i>Edit Profile
								</h4>

								<form
									action="${pageContext.request.contextPath}/AdminProfileServlet"
									method="post" enctype="multipart/form-data">
									<input type="hidden" name="existingImage"
										value="${profile.image}">

									<div class="row">
										<div class="col-md-6 mb-3">
											<label class="form-label">Full Name</label> <input
												type="text" name="name" class="form-control form-control-lg"
												value="${profile.name}" required>
										</div>
										<div class="col-md-6 mb-3">
											<label class="form-label">Email</label> <input type="email"
												name="email" class="form-control form-control-lg"
												value="${profile.email}" required>
										</div>
									</div>

									<div class="row">
										<div class="col-md-6 mb-3">
											<label class="form-label">Password</label> <input
												type="password" name="password"
												class="form-control form-control-lg"
												placeholder="Leave blank to keep current password">
										</div>
										<div class="col-md-6 mb-3">
											<label class="form-label">Phone</label> <input type="text"
												name="phone" class="form-control form-control-lg"
												value="${profile.phone}" placeholder="Mobile number">
										</div>
									</div>

									<div class="mb-3">
										<label class="form-label">Address</label>
										<textarea name="address" class="form-control" rows="1"
											placeholder="Your address">${profile.address}</textarea>
									</div>

									<div class="mb-4">
										<label class="form-label">Profile Image</label> <input
											type="file" name="imageFile" class="form-control"
											accept="image/*">
										<div class="form-text">Upload a JPG, PNG, or WEBP image
											to update your avatar.</div>
									</div>

									<div class="d-flex flex-wrap gap-2 justify-content-end">
										<a href="${pageContext.request.contextPath}/AdminServlet"
											class="btn btn-outline-secondary"> Cancel </a>
										<button type="submit" class="btn btn-outline-primary">
											<i class="bi bi-check2-circle me-1"></i>Save Profile
										</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>

			</div>

		</div>

	</div>

</body>
</html>
