<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
body {
	background: #f5f7fb;
}

.page-wrap {
	padding-left: 20.5rem;
	padding-right: 1.5rem;
}

.sidebar {
	position: fixed;
	top: 0;
	left: 0;
	width: 18.75rem;
	height: 100vh;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	background: #111827;
	color: #fff;
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

.sidebar a:hover, .sidebar a.active {
	background: rgba(255, 255, 255, 0.12);
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

.user-avatar {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.14);
	overflow: hidden;
	border: 3px solid rgba(255, 255, 255, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	flex: 0 0 auto;
}

.user-avatar-large {
	width: 88px;
	height: 88px;
	border-radius: 50%;
	background: linear-gradient(135deg, #6366f1, #8b5cf6);
	overflow: hidden;
	border: 4px solid rgba(255, 255, 255, 0.9);
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
	font-size: 2rem;
	box-shadow: 0 10px 24px rgba(99, 102, 241, .25);
}

.profile-avatar-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
	border-radius: 50%;
}

.min-w-0 {
	min-width: 0;
}

.card {
	border: none;
	border-radius: 18px;
}

.hero-card {
	background: linear-gradient(135deg, #0ea5e9, #2563eb);
	color: #fff;
}

.book-thumb {
	width: 100%;
	height: 190px;
	object-fit: cover;
	border-top-left-radius: 18px;
	border-top-right-radius: 18px;
}

.featured-book-card {
	overflow: hidden;
}

.featured-book-media {
	min-height: 100%;
	background: #f8fafc;
}

.featured-book-cover {
	width: 100%;
	height: 100%;
	min-height: 220px;
	object-fit: cover;
}

.featured-book-fallback {
	min-height: 220px;
	background: linear-gradient(135deg, #eef2ff, #e2e8f0);
}

.book-description {
	display: -webkit-box;
	-webkit-line-clamp: 3;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.book-fallback {
	height: 190px;
	border-top-left-radius: 18px;
	border-top-right-radius: 18px;
	background: linear-gradient(135deg, #eef2ff, #e2e8f0);
}

.section-title {
	letter-spacing: .2px;
}

@media ( max-width : 767.98px) {
	.page-wrap {
		padding-left: 0;
		padding-right: 0;
	}
	.sidebar {
		position: static;
		width: 100%;
		height: auto;
		overflow: visible;
	}
}
</style>
</head>
<body>
	<%
	String role = (String) session.getAttribute("role");
	if (role == null) {
		response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
		return;
	}
	if ("admin".equals(role)) {
		response.sendRedirect(request.getContextPath() + "/AdminServlet");
		return;
	}
	%>

	<div class="container-fluid page-wrap">
		<div class="row">
			<div class="col-md-2 sidebar">
				<div class="d-flex align-items-center gap-3 mb-4">
					<div class="user-avatar">
						<c:choose>
							<c:when test="${not empty sessionScope.profileImage}">
								<img class="profile-avatar-img"
									src="${pageContext.request.contextPath}/images/${sessionScope.profileImage}"
									alt="${sessionScope.user}">
							</c:when>
							<c:otherwise>
								<i class="bi bi-person-circle fs-2"></i>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="min-w-0">
						<div class="fw-semibold text-truncate">${sessionScope.user}</div>
						<div class="small text-white-50 text-truncate">${sessionScope.email}</div>
					</div>
				</div>

				<div class="sidebar-menu">
					<a class="active" href="${pageContext.request.contextPath}/dashboard"> <i class="bi bi-speedometer2"> </i>Dashboard</a>
				    <a href="${pageContext.request.contextPath}/books"><i class="bi bi-journal-bookmark"></i>Browse Books</a> 
				    <a href="${pageContext.request.contextPath}/CartServlet"><i class="bi bi-cart3"></i>My Books</a> 
					<a href="#accountSection"><i class="bi bi-person-lines-fill"></i>Profile</a> 
					<a href="${pageContext.request.contextPath}/LogoutServlet" onclick="return confirm('Are you sure you want to logout?');"><i class="bi bi-box-arrow-right"></i>Logout</a>
				</div>

				<!-- div class="sidebar-footer">
                <div class="small text-white-50 mb-1">Cart items</div>
                <div class="h4 mb-0">${cartCount}</div>
            </div-->
			</div>

			<div class="col-md-10 p-4">
				<c:if test="${not empty sessionScope.error}">
					<div class="alert alert-danger shadow-sm mb-4">${sessionScope.error}</div>
					<%
					session.removeAttribute("error");
					%>
				</c:if>

				<c:if test="${not empty sessionScope.success}">
					<div class="alert alert-success shadow-sm mb-4">${sessionScope.success}</div>
					<%
					session.removeAttribute("success");
					%>
				</c:if>

				<div class="card hero-card shadow-sm mb-4">
					<div
						class="card-body p-4 p-lg-5 d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
						<div>
							<div class="badge text-bg-light text-primary mb-3">Welcome
								back</div>
							<h2 class="mb-2">Hello, ${sessionScope.user}</h2>
							<p class="mb-0 opacity-75">Discover books, manage your cart,
								and jump back into reading from one place.</p>
						</div>
						<div class="d-flex flex-wrap gap-2">
							<a href="${pageContext.request.contextPath}/books"
								class="btn btn-light btn-lg"><i class="bi bi-search me-1"></i>Browse
								Books</a> <a href="${pageContext.request.contextPath}/CartServlet"
								class="btn btn-outline-light btn-lg"><i
								class="bi bi-cart3 me-1"></i>Open Cart</a>
						</div>
					</div>
				</div>

				<div class="row g-3 mb-4">
					<div class="col-md-4">
						<div class="card shadow-sm h-100">
							<div class="card-body d-flex align-items-center gap-3">
								<div
									class="rounded-circle bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center"
									style="width: 56px; height: 56px;">
									<i class="bi bi-book fs-4"></i>
								</div>
								<div>
									<div class="text-muted small">Books available</div>
									<div class="h4 mb-0">${booksCount}</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card shadow-sm h-100">
							<div class="card-body d-flex align-items-center gap-3">
								<div
									class="rounded-circle bg-success bg-opacity-10 text-success d-flex align-items-center justify-content-center"
									style="width: 56px; height: 56px;">
									<i class="bi bi-cart-check fs-4"></i>
								</div>
								<div>
									<div class="text-muted small">Cart items</div>
									<div class="h4 mb-0">${cartCount}</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card shadow-sm h-100">
							<div class="card-body d-flex align-items-center gap-3">
								<div
									class="rounded-circle bg-warning bg-opacity-10 text-warning d-flex align-items-center justify-content-center"
									style="width: 56px; height: 56px;">
									<i class="bi bi-stars fs-4"></i>
								</div>
								<div>
									<div class="text-muted small">Account status</div>
									<div class="h4 mb-0">Active</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="row g-3">
					<div class="col-lg-8">
						<div class="card shadow-sm">
							<div class="card-body p-4">
								<div
									class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
									<div>
										<h4 class="section-title mb-1">Featured Books</h4>
										<div class="text-muted">Quick picks you can add to your
											cart right away.</div>
									</div>
									<a href="${pageContext.request.contextPath}/books"
										class="btn btn-outline-primary">View all books</a>
								</div>

								<div class="row g-4">
									<c:choose>
										<c:when test="${empty featuredBooks}">
											<div class="col-12">
												<div class="alert alert-info mb-0">No books available
													right now.</div>
											</div>
										</c:when>
										<c:otherwise>
											<c:forEach var="book" items="${featuredBooks}">
												<div class="col-md-6">
													<div class="card shadow-sm h-100 featured-book-card">
														<div class="row g-0 h-100">
															<div class="col-md-4 featured-book-media">
																<c:choose>
																	<c:when
																		test="${not empty book.imageUrl and (fn:startsWith(book.imageUrl, 'http://') or fn:startsWith(book.imageUrl, 'https://') or fn:startsWith(book.imageUrl, 'data:'))}">
																		<img class="featured-book-cover"
																			src="${book.imageUrl}" alt="${book.title}">
																	</c:when>
																	<c:when test="${not empty book.imageUrl}">
																		<img class="featured-book-cover"
																			src="${pageContext.request.contextPath}${book.imageUrl}"
																			alt="${book.title}">
																	</c:when>
																	<c:otherwise>
																		<div
																			class="featured-book-fallback h-100 d-flex align-items-center justify-content-center text-muted">
																			<div class="text-center">
																				<i class="bi bi-book fs-1 d-block mb-2"></i> No
																				Image
																			</div>
																		</div>
																	</c:otherwise>
																</c:choose>
															</div>
															<div class="col-md-8">
																<div class="card-body h-100 d-flex flex-column">
																	<div>
																		<h5 class="mb-1">${book.title}</h5>
																		<div class="text-muted small mb-2">${book.author}</div>
																		<div class="book-description text-muted small mb-3">
																			<c:choose>
																				<c:when test="${not empty book.description}">${book.description}</c:when>
																				<c:otherwise>No description available.</c:otherwise>
																			</c:choose>
																		</div>
																	</div>

																	<div class="mt-auto">
																		<div class="fw-semibold text-success mb-3">₹
																			${book.price}</div>
																		<div class="mb-3">
																			<c:choose>
																				<c:when test="${book.quantity > 0}">
																					<span class="badge bg-success">In Stock</span>
																				</c:when>
																				<c:otherwise>
																					<span class="badge bg-danger">Out of Stock</span>
																				</c:otherwise>
																			</c:choose>
																			<span class="small text-muted ms-2">${book.quantity}
																				left</span>
																		</div>
																		<c:choose>
																			<c:when test="${book.quantity > 0}">
																				<button type="button" class="btn btn-primary w-100"
																					data-bs-toggle="modal"
																					data-bs-target="#paymentModal"
																					data-book-id="${book.id}"
																					data-book-title="${book.title}"
																					data-action="buyNow">
																					<i class="bi bi-bag-check me-1"></i>Buy Now
																				</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button"
																					class="btn btn-secondary w-100" disabled="disabled">
																					<i class="bi bi-bag-check me-1"></i>Out of Stock
																				</button>
																			</c:otherwise>
																		</c:choose>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-4" id="accountSection">
						<div class="card shadow-sm h-100">
							<div class="card-body p-4">
								<div class="d-flex align-items-center gap-3 mb-4">
									<div class="user-avatar-large">
										<c:choose>
											<c:when test="${not empty sessionScope.profileImage}">
												<img class="profile-avatar-img"
													src="${pageContext.request.contextPath}/images/${sessionScope.profileImage}"
													alt="${sessionScope.user}">
											</c:when>
											<c:otherwise>
												<i class="bi bi-person"></i>
											</c:otherwise>
										</c:choose>
									</div>
									<div class="min-w-0">
										<h4 class="mb-1 text-truncate">${sessionScope.user}</h4>
										<div class="text-muted text-truncate">${sessionScope.email}</div>
									</div>
								</div>

								<div class="list-group list-group-flush">
									<div
										class="list-group-item d-flex justify-content-between align-items-center px-0">
										<span><i class="bi bi-envelope me-2 text-primary"></i>Email</span>
										<span class="small text-muted text-end">${sessionScope.email}</span>
									</div>
									<div
										class="list-group-item d-flex justify-content-between align-items-center px-0">
										<span><i class="bi bi-person-badge me-2 text-primary"></i>Role</span>
										<span class="badge text-bg-secondary">${sessionScope.role}</span>
									</div>
									<div
										class="list-group-item d-flex justify-content-between align-items-center px-0">
										<span><i class="bi bi-cart3 me-2 text-primary"></i>Cart
											items</span> <span class="badge text-bg-success">${cartCount}</span>
									</div>
								</div>

								<div class="alert alert-primary mt-4 mb-0">Use the sidebar
									to open books, revisit your cart, or log out safely.</div>

								<div class="border rounded-4 p-3 mt-4 bg-light">
									<!-- div class="d-flex justify-content-between align-items-center gap-3 mb-3">
                                    <div>
                                        <div class="fw-semibold">Profile image</div>
                                        <div class="small text-muted">Upload a new image to update your avatar everywhere.</div>
                                    </div>
                                    <span class="badge text-bg-primary">Dynamic</span>
                                </div-->

									<form
										action="${pageContext.request.contextPath}/UserProfileServlet"
										method="post" enctype="multipart/form-data">
										<div class="mb-3">
											<label class="form-label">Choose image</label> <input
												type="file" name="imageFile" class="form-control"
												accept="image/*" required>
										</div>
										<button type="submit" class="btn btn-primary w-100">
											<i class="bi bi-upload me-1"></i>Upload Profile Image
										</button>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="paymentModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<form action="${pageContext.request.contextPath}/CartServlet"
					method="post">
					<div class="modal-header">
						<h5 class="modal-title">Dummy Payment Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<!-- div class="alert alert-info small">Demo payment only. Fill
							in the fields below to continue.</div-->
						<div class="mb-3">
							<label class="form-label">Selected Book</label>
							<div class="form-control bg-light" id="paymentBookTitle">Book</div>
						</div>
						<input type="hidden" name="action" id="paymentAction"
							value="buyNow"> <input type="hidden" name="bookId"
							id="paymentBookId"> <input type="hidden"
							name="removeIndex" id="paymentRemoveIndex">
						<div class="mb-3">
							<label class="form-label">Card Holder Name</label> <input
								type="text" name="paymentName" class="form-control"
								placeholder="card holder" required>
						</div>
						<div class="mb-3">
							<label class="form-label">Card Number</label> <input type="text"
								name="paymentNumber" class="form-control"
								placeholder="4111 1511 1161 1117" required>
						</div>
						<div class="row g-3">
							<div class="col-md-6 mb-3">
								<label class="form-label">Expiry</label> <input type="text"
									name="paymentExpiry" class="form-control" placeholder="MM/YY"
									required>
							</div>
							<div class="col-md-6 mb-3">
								<label class="form-label">CVV</label> <input type="password"
									name="paymentCvv" class="form-control" placeholder="123"
									required>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-outline-primary">Continue
							Payment</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		const paymentModal = document.getElementById('paymentModal');
		if (paymentModal) {
			paymentModal
					.addEventListener(
							'show.bs.modal',
							function(event) {
								const button = event.relatedTarget;
								if (!button)
									return;

								const action = button
										.getAttribute('data-action')
										|| 'buyNow';
								const bookId = button
										.getAttribute('data-book-id')
										|| '';
								const bookTitle = button
										.getAttribute('data-book-title')
										|| 'Book';
								const removeIndex = button
										.getAttribute('data-remove-index')
										|| '';

								document.getElementById('paymentAction').value = action;
								document.getElementById('paymentBookId').value = bookId;
								document.getElementById('paymentRemoveIndex').value = removeIndex;
								document.getElementById('paymentBookTitle').textContent = bookTitle;
							});
		}
	</script>
</body>
</html>
