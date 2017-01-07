component extends="Admin"
{
	function init() {
		super.init();
		filters(through="checkPermissionAndRedirect", permission="accessBookings");
		verifies(except="index,new,create", params="key", paramsTypes="integer", handler="objectNotFound");
		verifies(post=true, only="create,update,delete");
		filters(through="f_getBuildings,f_getRooms,f_getUsers", only="index,new,edit,create,update");
	}

	function index(){
		param name="params.page" default="1";
		param name="params.perpage" default="50";
		param name="params.sort" default="startUTC";
		param name="params.sortorder" default="ASC";
		request.pagetitle="Bookings";
		bookings=model("bookings").findAll(perpage=params.perpage, page=params.page, order="#params.sort# #params.sortorder#");
	}

	function show() {
		request.pagetitle="Booking Information";
		booking=model("booking").findByKey(params.key);
		if(!isObject(booking)){
			objectNotFound();
		}
	}

	function new() {
		request.pagetitle="Create New Booking";
		booking=model("booking").new();
	}

	function create() {
		booking=model("booking").create(params.booking);
		if(booking.hasErrors()){
			renderPage(action="new");
		} else {
			return redirectTo(action="index", success="booking #booking.title# successfully created");
		}
	}

	function edit() {
		request.pagetitle="Update Booking";
		booking=model("booking").findByKey(params.key);
	}

	function update() {
		booking=model("booking").findByKey(params.key);
		if(booking.update(params.booking)){
			return redirectTo(action="index", success="booking #booking.title# successfully updated");
		} else {
			renderPage(action="edit");
		}
	}

	function delete() {
		booking=model("booking").deleteByKey(params.key);
		return redirectTo(action="index", success="booking successfully deleted");
	}

	function objectNotFound() {
		return redirectTo(action="index", error="That booking wasn't found");
	}

}