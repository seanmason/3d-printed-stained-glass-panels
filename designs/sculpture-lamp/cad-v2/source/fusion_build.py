import adsk.core, adsk.fusion, json, re, math
from pathlib import Path

ROOT = Path(r'C:\Users\mason\Documents\Codex\2026-09-15\i-d\archive-repo\designs\sculpture-lamp\cad-v2')

def run(_context: str):
    app = adsk.core.Application.get()
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    if root.bRepBodies.count == 0:
        design.designType = adsk.fusion.DesignTypes.DirectDesignType
    existing = {re.sub(r' \(\d+\)$', '', b.name) for b in root.bRepBodies}
    data = json.loads((ROOT/'fusion-body-input.json').read_text())
    pending = [p for p in data if p['id'] not in existing][:60]
    for part in pending:
        definition = adsk.fusion.BRepBodyDefinition.create()
        definition.doFullHealing = True
        shell = definition.lumpDefinitions.add().shellDefinitions.add()
        points = [adsk.core.Point3D.create(*(v/10 for v in xyz)) for xyz in part['vertices']]
        vertices = [definition.createVertexDefinition(p) for p in points]
        edges = {}
        for tri in part['faces']:
            i,j,k = tri
            aa=part['vertices'][i];bb=part['vertices'][j];cc=part['vertices'][k]
            ab=[bb[t]-aa[t] for t in range(3)];ac=[cc[t]-aa[t] for t in range(3)]
            xyz=[ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]]
            ln=math.sqrt(sum(x*x for x in xyz))
            if ln<1e-12: continue
            normal=adsk.core.Vector3D.create(*(x/ln for x in xyz))
            face = shell.faceDefinitions.add(adsk.core.Plane.create(points[i], normal), False)
            loop = face.loopDefinitions.add()
            for a,b in ((i,j),(j,k),(k,i)):
                key = tuple(sorted((a,b)))
                if key not in edges:
                    aa,bb = key
                    edges[key] = definition.createEdgeDefinitionByCurve(vertices[aa],vertices[bb],adsk.core.Line3D.create(points[aa],points[bb]))
                loop.bRepCoEdgeDefinitions.add(edges[key], a>b)
        body = definition.createBody()
        if body is None:
            raise RuntimeError(part['id']+': '+str(definition.outcomeInfo))
        result = root.bRepBodies.add(body)
        result.name = part['id']
        if not result.isSolid or result.volume <= 0:
            raise RuntimeError(part['id']+' did not produce a positive solid')
    app.activeViewport.fit()
    print(json.dumps({'created':len(pending),'total':root.bRepBodies.count,'target':len(data)}))


