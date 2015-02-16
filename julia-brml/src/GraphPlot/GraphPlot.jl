module GraphPlot


importall DavidsFunctions
using PyPlot

export VariablePlot
type VariablePlot
    text
    x
    y
    nodetype
    nodecolor
    nodesize
    function VariablePlot(text;x=0,y=0,nodetype="circle",nodecolor="black",nodesize=0.05)
        new(text,x,y,nodetype,nodecolor,nodesize)
    end
end

export PlotGraph
function PlotGraph{I<:Number}(D::Dict{Integer,VariablePlot},L::Dict{Integer,Array{I,}};arrowsize=0.1,arrowtheta=0.25,arrowcolor="black",PlotBidirectionalEdgeAsUndirected=true) # D is the Variable Dictionary and L is the Dictionary List of directed connections

    an=linspace(0,2*pi,100)
    for i=1:length(D)
        xx=D[i].x; yy=D[i].y
        annotate(D[i].text,xy=[xx;yy],horizontalalignment="center",verticalalignment="center")
        if D[i].nodetype=="circle"
            r=D[i].nodesize
            plot(xx+r*cos(an),yy+r*sin(an),color=D[i].nodecolor)
        end
    end
    axis("equal")

    ky=collect(keys(L))
    lambda=linspace(0,1,100)
    for i=ky
        for j=L[i]
            xstart=D[i].x; xend=D[j].x
            ystart=D[i].y; yend=D[j].y
            sx=sign(xstart-xend)
            sy=sign(ystart-yend)

            theta=atan( (yend-ystart)/(xend-xstart))

            if D[j].nodetype=="circle" && D[i].nodetype=="circle"
                rstart=D[i].nodesize
                rend=D[j].nodesize
                xxstart=xstart-sx*rstart*cos(theta)
                yystart=ystart-sx*rstart*sin(theta)
                xxend=xend+sx*rend*cos(theta)
                yyend=yend+sx*rend*sin(theta)

                plot(lambda*xxstart+(1-lambda)*xxend,lambda*yystart+(1-lambda)*yyend,color=arrowcolor)


                if iskey(j,L) && any(L[j].==i)
                    bidirectionaledge=true
                else
                    bidirectionaledge=false
                end

                if !bidirectionaledge | (bidirectionaledge && !PlotBidirectionalEdgeAsUndirected)
                    # add an arrow:
                    Ax=xxend; Ay=yyend;
                    Bx=Ax+arrowsize*cos(pi*(sx==-1)+theta-arrowtheta)
                    By=Ay+arrowsize*sin(pi*(sx==-1)+theta-arrowtheta)
                    plot(lambda*Ax+(1-lambda)*Bx,lambda*Ay+(1-lambda)*By,color=arrowcolor)

                    Cx=Ax+arrowsize*cos(pi*(sx==-1)+theta+arrowtheta)
                    Cy=Ay+arrowsize*sin(pi*(sx==-1)+theta+arrowtheta)
                    plot(lambda*Ax+(1-lambda)*Cx,lambda*Ay+(1-lambda)*Cy,color=arrowcolor)

                    plot(lambda*Bx+(1-lambda)*Cx,lambda*By+(1-lambda)*Cy,color=arrowcolor)
                    end
            end
        end
    end

end

include("make_layout.jl")
include("poset.jl")
include("toposort.jl")


export PlaceVertices
function PlaceVertices(D,L;UseEnergyApproach=false,scale=4,crosspenalty=0.5,proximitypenalty=2,linelengthpenalty=0.5,attempts=200)


    if UseEnergyApproach
        ## This is just a quick attempt to places vertices such that they prefer not to be too close and also for connecting lines not to cross. Needs more work!

        Ebest=1000000000
        DDD=deepcopy(D)
        for goes=1:attempts
            V=length(D) # number of variables
            an=linspace(0,2pi,V)
            DD=deepcopy(D)
            for i=1:V
                #DD[i].x=cos(an[i]);     DD[i].y=sin(an[i])
                DD[i].x=scale*rand();     DD[i].y=scale*rand()
            end

            E=DAGenergy(DD,L,scale,crosspenalty,proximitypenalty,linelengthpenalty)
            for loop=1:10
                for v=randperm(V)
                    Dcand=deepcopy(DD)
                    Dcand[v].x=scale*rand()
                    Dcand[v].y=scale*rand()
                    Ecand=DAGenergy(DD,L,scale,crosspenalty,proximitypenalty,linelengthpenalty)
                    if Ecand<E
                        E=Ecand
                        DD[v]=deepcopy(Dcand[v])
                    end
                end
            end
            if E<Ebest
                Ebest=E
                DDD=deepcopy(DD)
            #println(Ebest)
            end

        end

        return DDD
    else # use Taylan's method:
        DD=deepcopy(D)
        V=length(D)
        A=zeros(V,V)
        for i=collect(keys(L))
            for j=L[i]
                A[i,j]=1
            end
        end
        xx,yy=make_layout(A)
        for i=1:V
            DD[i].x=scale*xx[i]
            DD[i].y=scale*yy[i]
        end
        return DD

    end

end

export DAGenergy
function DAGenergy(points,L,scale=4,crosspenalty=0.5,proximitypenalty=2,linelengthpenalty=0.5)

    E=0.0;
    if true
    for i=1:length(points)
        vi=vec([points[i].x,points[i].y])
        for j=setdiff(1:length(points),i)
            vj=vec([points[j].x,points[j].y])
            d=vi-vj;
            dist=sqrt(dot(d,d))
                if dist<0.1*scale
                    E=E+1
                elseif dist>0.5*scale
                    E=E+1
                end
        end
    end
    E=proximitypenalty*E
    end
    if true
        for a=collect(keys(L))
            for b=L[a]
                aa=vec([points[a].x points[a].y])
                bb=vec([points[b].x points[b].y])
                E=E+linelengthpenalty*sqrt(dot( bb-aa,bb-aa)) # encourage lines to not be too long

                for c=setdiff(collect(keys(L)),[a b])
                    for d=setdiff(L[c],[a b])
                        E=E+crosspenalty*linescross(points[a],points[b],points[c],points[d])
                    end
                end
            end
        end
    end
    return E
end


export linescross
function linescross(line1start,line1end,line2start,line2end)
    # returns true is line1 crosses line2
    a=vec([line1start.x line1start.y])
    b=vec([line1end.x line1end.y])
    c=vec([line2start.x line2start.y])
    d=vec([line2end.x line2end.y])

    g=a-c;e=b-a;f=d-c;

    alpha=dot(e,e); beta=-dot(f,e); theta=-dot(g,e);
    gamma=dot(e,f); delta=-dot(f,f); phi=-dot(g,f);
    mu=(alpha*phi-theta*gamma)/(delta*alpha-beta*gamma)
    lambda=(theta-mu*beta)/alpha
    v=g+lambda*e-mu*f
    E=dot(v,v)

    if 0<= lambda <=1 && 0<=mu<=1 && E<0.0001
        return true
    else
        return false
    end
end


end

