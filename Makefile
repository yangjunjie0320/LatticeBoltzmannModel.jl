jl:=julia

init: 
	$(jl) -e 'd=pwd(); @assert isdir(d);\
	using Pkg: activate, instantiate, develop, precompile; \
	activate(d); instantiate(); activate(joinpath(d, "examples")); \
	develop(path=d); instantiate(); precompile();'
	@echo "environment initialized at: $$PWD"

update:
	$(jl) -e 'd=pwd(); @assert isdir(d);\
	using Pkg: activate, update, develop, precompile; \
	activate(d); update(); activate(joinpath(d, "examples")); \
	update(); precompile();'
	@echo "environment updated at: $$PWD"

run:
	@echo "running tests at: $$PWD"
	$(jl) -e 'd=pwd(); @assert isdir(d);\
	using Pkg: activate, test; \
	activate(d); test();'

	@echo "running examples at: $$PWD"
	$(jl) -e 'd=joinpath(pwd(), "examples"); @assert isdir(d);\
	using Pkg: activate; \
	activate(d); include(joinpath(d, "barrier.jl"));'
